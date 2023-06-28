import 'dart:io';

import 'package:domain_models/domain_models.dart';
import 'package:flutter/widgets.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_profile_state.dart';

import 'dart:developer' as dev;

class UserProfileCubit extends Cubit<UserProfileState> {
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController photoURLController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  late TextEditingController? passwordController;
  final UserRepository userRepository;

  UserProfileCubit({required this.userRepository})
      : super(UserProfileInitial()) {
    if (userRepository.isEmailPasswordLogin()) {
      passwordController = TextEditingController();
    } else {
      passwordController = null;
    }
  }

  Future<void> updateUserProfile() async {
    try {
      emit(UserProfileLoading());

      String displayName = displayNameController.text;
      String password =
          passwordController != null ? passwordController!.text : '';
      String photoURL = photoURLController.text;

      await userRepository.updateUserInfo(displayName, password, photoURL);

      emit(UserProfileUpdated());
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> getUserProfile() async {
    try {
      emit(UserProfileLoading());

      User? user = await userRepository.getUserProfile();
      if (user != null) {
        displayNameController.text = user.name;
        photoURLController.text = user.imgUrl;
        emailController.text = user.email;
      } else {}

      emit(UserProfileLoaded());
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> updatePhotoURL(File photo) async {
    try {
      emit(UserProfileLoading());

      String photoURL = await userRepository.uploadPhoto(photo);
      photoURLController.text = photoURL;

      emit(UserProfilePhotoUpdated(photoURL));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _updateUserInfo(
      String displayName, String password, String photoURL) async {}
}
