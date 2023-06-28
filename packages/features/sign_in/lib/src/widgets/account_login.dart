import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:formz/formz.dart';

import '../../sign_in.dart';
import '../sign_in_cubit.dart';

class EmailPasswordLogin extends StatefulWidget {
  final _key = GlobalKey<FormState>();
  final OnSignUpLinkPressed onSignUpLinkPressed;
  EmailPasswordLogin({super.key, required this.onSignUpLinkPressed});

  @override
  State<EmailPasswordLogin> createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  late InputForm _state;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  void _onEmailChanged() {
    final email = Email.dirty(_emailController.text);
    setState(() {
      _state = _state.copyWith(
        email: email,
      );
    });
  }

  void _onPasswordChanged() {
    _state.password.validator(_passwordController.text);
    setState(() {
      _state = _state.copyWith(
        password: Password.dirty(_passwordController.text),
      );
    });
  }

  Future<void> _onSubmit(SigninCubit cubit) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }
    if (!widget._key.currentState!.validate()) return;
    cubit.signinUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
  }

  @override
  void initState() {
    super.initState();
    _state = InputForm();
    _emailController = TextEditingController(text: _state.email.value)
      ..addListener(_onEmailChanged);
    _passwordController = TextEditingController(text: _state.password.value)
      ..addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SigninCubit cubit = BlocProvider.of<SigninCubit>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: widget._key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EmailFormField(
              controller: _emailController,
              validator: (_) => _state.email.displayError?.text(),
            ),
            const SizedBox(height: 16.0),
            PasswordFormField(
              controller: _passwordController,
              validator: (_) => _state.password.displayError?.text(),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => _onSubmit(cubit),
              child: const Text('Login'),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: widget.onSignUpLinkPressed,
              child: const Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}

class InputForm with FormzMixin {
  final Email email;
  final Password password;

  InputForm({
    Email? email,
    this.password = const Password.pure(),
  }) : email = email ?? Email.pure();

  InputForm copyWith({
    Email? email,
    Password? password,
  }) {
    return InputForm(
        email: email ?? this.email, password: password ?? this.password);
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [email, password];
}

extension on EmailValidationError {
  String text() {
    switch (this) {
      case EmailValidationError.invalid:
        return 'Please ensure the email entered is valid';
    }
  }
}

extension on PasswordValidationError {
  String text() {
    switch (this) {
      case PasswordValidationError.invalid:
        return '''Password must be at least 8 characters and contain at least one letter and number''';
    }
  }
}
