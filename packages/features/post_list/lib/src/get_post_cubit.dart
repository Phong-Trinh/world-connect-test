import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'dart:developer' as dev;

import 'get_post_state.dart';

class GetPostCubit extends Cubit<GetPostState> {
  final PostRepository postRepository;

  GetPostCubit({required this.postRepository}) : super(GetPostInit());

  void getPosts() async {
    //dev.debugger();
    try {
      emit(GetPostLoading());
      final posts = await postRepository.getPosts();
      emit(GetPostSuccess(posts));
    } catch (e) {
      emit(GetPostFail(e.toString()));
    }
  }
}
