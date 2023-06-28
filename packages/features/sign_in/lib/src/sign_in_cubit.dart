import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'dart:developer' as dev;

import 'sign_in_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit({required this.userRepository}) : super(SigninInit());

  final UserRepository userRepository;

  Future<void> signinUserWithEmailAndPassword(
      {required String email, required String password}) async {
    emit(SigninLoading());
    try {
      await userRepository.loginWithEmailAndPassword(email, password);
      emit(SigninSuccess());
    } catch (_) {
      emit(SigninFail());
    }
  }

  Future<void> signinUserWithGoogle() async {
    emit(SigninLoading());
    try {
      final user = await userRepository.signinUserWithGoogle();
      if (user != null) {
        emit(SigninSuccess());
      } else {
        emit(SigninFail());
      }
    } catch (e) {
      emit(SigninFail());
    }
  }

  Future<void> sendOTP(String phoneNumber) async {
    emit(SigninLoading());
    try {
      String? verificationId = await userRepository.sendOTP('+84$phoneNumber');
      if (verificationId != null) {
        emit(SigninOTPSent(verificationId));
      } else {
        emit(SigninFail());
      }
    } catch (e) {
      print(e.toString());
      emit(SigninFail());
    }
  }

  Future<void> verifyPhoneNumber(
      {required String verificationId, required String otp}) async {
    emit(SigninLoading());
    try {
      final user = await userRepository.verifyPhoneNumber(
          verificationId: verificationId, otp: otp);
      if (user != null) {
        emit(SigninSuccess());
      } else {
        emit(SigninFail());
      }
    } catch (e) {
      print(e.toString());
      emit(SigninFail());
    }
  }
}
