import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_up/src/sign_up_state.dart';
import 'package:user_repository/user_repository.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.userRepository}) : super(SignUpInit());

  final UserRepository userRepository;

  Future<void> signupUser(
      {required String email,
      required String password,
      required String name}) async {
    emit(SignUpLoading());
    try {
      await userRepository.createUserWithEmailAndPassword(
          email, password, name);
      emit(SignUpSuccess());
    } catch (_) {
      emit(SignUpFail());
    }
  }
}
