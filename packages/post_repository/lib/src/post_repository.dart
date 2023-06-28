import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_models/domain_models.dart' as model;

import 'post_rm_model.dart';

class PostRepository {
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<List<model.Post>> getPosts() async {
    final snapshot =
        await postCollection.orderBy('createdAt', descending: true).get();
    final posts = snapshot.docs
        .map((doc) => PostRM.fromSnapshot(doc).toDomainModel())
        .toList();
    return posts;
  }

  Future<String> uploadImageToStorage(File image) async {
    final storageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('post_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() {});

    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> createPostWithImage(String content, File image) async {
    String imageUrl = await uploadImageToStorage(image);
    final post = PostRM(
      id: postCollection.doc().id,
      content: content,
      imgUrl: imageUrl,
      createdAt: Timestamp.now(),
    );

    await postCollection.doc(post.id).set(post.toMap());
  }
}

extension PostRMtoDomain on PostRM {
  model.Post toDomainModel() {
    return model.Post(
      id: id,
      content: content,
      imgUrl: imgUrl,
    );
  }
}
