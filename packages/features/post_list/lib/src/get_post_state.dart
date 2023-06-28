import 'package:domain_models/domain_models.dart';

class GetPostState {
  const GetPostState();
}

class GetPostInit extends GetPostState {}

class GetPostLoading extends GetPostState {}

class GetPostSuccess extends GetPostState {
  final List<Post> posts;

  GetPostSuccess(this.posts);
}

class GetPostFail extends GetPostState {
  final String errorMessage;

  GetPostFail(this.errorMessage);
}
