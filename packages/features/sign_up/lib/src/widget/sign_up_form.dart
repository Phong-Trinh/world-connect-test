import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

import '../sign_up_cubit.dart';
import '../sign_up_state.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({super.key});

  final _key = GlobalKey<FormState>();

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late SignUpInputForm _state;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;

  void _onEmailChanged() {
    setState(() {
      _state = _state.copyWith(email: Email.dirty(_emailController.text));
    });
  }

  void _onPasswordChanged() {
    setState(() {
      _state = _state.copyWith(
        password: Password.dirty(_passwordController.text),
      );
    });
  }

  void _onNameChanged() {
    setState(() {
      _state = _state.copyWith(
        name: Name.dirty(value: _nameController.text),
      );
    });
  }

  Future<void> _onSubmit(SignUpCubit cubit) async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) return;
    if (!widget._key.currentState!.validate()) return;
    cubit.signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text);
  }

  void _resetForm() {
    widget._key.currentState!.reset();
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    setState(() => _state = SignUpInputForm());
  }

  @override
  void initState() {
    super.initState();
    _state = SignUpInputForm();
    _emailController = TextEditingController(text: _state.email.value)
      ..addListener(_onEmailChanged);
    _passwordController = TextEditingController(text: _state.password.value)
      ..addListener(_onPasswordChanged);
    _nameController = TextEditingController(text: _state.name.value)
      ..addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignUpCubit cubit = SignUpCubit(
        userRepository: RepositoryProvider.of<UserRepository>(context));
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
              content: Text('Registering user....'),
            ));
        } else if (state is SignUpSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
              content: Text('Submitted successfully! 🎉'),
            ));
          _resetForm();
        } else if (state is SignUpFail) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
              content: Text('Something went wrong... 🚨'),
            ));
        }
      },
      bloc: cubit,
      child: Form(
        key: widget._key,
        child: Column(
          children: [
            NameFormField(
              controller: _nameController,
              validator: (_) => _state.name.displayError?.text(),
            ),
            EmailFormField(
              controller: _emailController,
              validator: (_) => _state.email.displayError?.text(),
            ),
            PasswordFormField(
              controller: _passwordController,
              validator: (_) => _state.password.displayError?.text(),
            ),
            const SizedBox(height: 24),
            const Spacer(),
            if (_state.status.isInProgress)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () => _onSubmit(cubit),
                child: const Text('Submit'),
              ),
          ],
        ),
      ),
    );
  }
}

class SignUpInputForm with FormzMixin {
  final Email email;
  final Password password;
  final Name name;
  final FormzSubmissionStatus status;

  SignUpInputForm({
    Email? email,
    this.password = const Password.pure(),
    Name? name,
    this.status = FormzSubmissionStatus.initial,
  })  : email = email ?? Email.pure(),
        name = name ?? const Name.pure();

  SignUpInputForm copyWith({
    Email? email,
    Password? password,
    Name? name,
    FormzSubmissionStatus? status,
  }) {
    return SignUpInputForm(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [email, password, name];
}

extension on PasswordValidationError {
  String text() {
    switch (this) {
      case PasswordValidationError.invalid:
        return '''Password must be at least 8 characters and contain at least one letter and number''';
    }
  }
}

extension on NameValidationError {
  String text() {
    switch (this) {
      case NameValidationError.empty:
        return '''Name must not be empty''';
    }
  }
}

extension on EmailValidationError {
  String text() {
    switch (this) {
      case EmailValidationError.invalid:
        return 'Please ensure the email entered is valid';
    }
  }
}
