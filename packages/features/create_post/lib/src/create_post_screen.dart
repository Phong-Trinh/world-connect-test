import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_repository/post_repository.dart';

import 'create_post_cubit.dart';
import 'create_post_state.dart';

typedef OnCreatePostSuccess = void Function();

class CreatePostScreen extends StatefulWidget {
  static const routeName = 'CreatePostScreenRoute';
  final OnCreatePostSuccess onCreatePostSuccess;

  const CreatePostScreen({Key? key, required this.onCreatePostSuccess})
      : super(key: key);

  @override
  CreatePostScreenState createState() => CreatePostScreenState();
}

class CreatePostScreenState extends State<CreatePostScreen> {
  File? _image;
  final TextEditingController _contentController = TextEditingController();
  late CreatePostCubit _createPostCubit;

  @override
  void initState() {
    _createPostCubit = CreatePostCubit(
        postRepository: RepositoryProvider.of<PostRepository>(context));
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _createPostCubit.close();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _createPost() {
    final content = _contentController.text;

    _createPostCubit.createPost(content, _image);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _createPostCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state is CreatePostSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tạo bài viết thành công!!')),
              );
              widget.onCreatePostSuccess();
            } else if (state is CreatePostFailure) {
              final errorMessage = state.errorMessage;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
            }
          },
          builder: (context, state) {
            if (state is CreatePostLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextField(
                    controller: _contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 200.0,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : IconButton(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.photo_library),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _createPost,
                    child: const Text('Create'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
