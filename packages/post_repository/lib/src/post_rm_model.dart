import 'package:cloud_firestore/cloud_firestore.dart';

class PostRM {
  final String id;
  final String content;
  final String imgUrl;
  final Timestamp createdAt;

  PostRM(
      {required this.id,
      required this.content,
      required this.imgUrl,
      required this.createdAt});

  factory PostRM.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final id = snapshot.id;
    final content = data['content'] as String;
    final imgUrl = data['imgUrl'] as String;
    final createdAt = data['createdAt'] as Timestamp;

    return PostRM(
        id: id, content: content, imgUrl: imgUrl, createdAt: createdAt);
  }

  Map<String, dynamic> toMap() {
    return {'content': content, 'imgUrl': imgUrl, 'createdAt': createdAt};
  }
}
