import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'sign_up_cubit.dart';
import 'widget/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static const String routeName = 'signUpScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocProvider(
            create: (_) => SignUpCubit(
                userRepository: RepositoryProvider.of<UserRepository>(context)),
            child: SignUpForm()),
      ),
    );
  }
}
