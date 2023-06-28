import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';

import 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository postRepository;

  CreatePostCubit({required this.postRepository}) : super(CreatePostInitial());

  Future<void> createPost(String content, File? image) async {
    emit(CreatePostLoading());
    if (content.isEmpty || image == null) {
      emit(CreatePostFailure(errorMessage: 'Field can not be empty'));
      return;
    }
    try {
      emit(CreatePostLoading());
      await postRepository.createPostWithImage(content, image);
      emit(CreatePostSuccess());
    } catch (e) {
      emit(CreatePostFailure(errorMessage: 'Failed to create post.'));
    }
  }
}
