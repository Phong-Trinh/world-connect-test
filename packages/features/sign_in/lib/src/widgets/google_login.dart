import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../sign_in_cubit.dart';

class GoogleLogin extends StatelessWidget {
  const GoogleLogin({super.key});

  @override
  Widget build(BuildContext context) {
    SigninCubit cubit = BlocProvider.of<SigninCubit>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              cubit.signinUserWithGoogle();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/google_logo.png', height: 24.0),
                const SizedBox(width: 8.0),
                const Text('Login with Google'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
