import 'package:flutter/material.dart';

class NameFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const NameFormField({
    super.key,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Name',
      ),
      validator: validator,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
    );
  }
}

class EmailFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const EmailFormField({
    super.key,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        icon: Icon(Icons.email),
        labelText: 'Email',
        helperText: 'A valid email e.g. joe.doe@gmail.com',
      ),
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }
}

class PasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordFormField({
    super.key,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        icon: Icon(Icons.lock),
        helperText: 'At least 8 characters including one letter and number',
        helperMaxLines: 2,
        labelText: 'Password',
        errorMaxLines: 2,
      ),
      validator: validator,
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }
}

class PhoneNumberFormField extends StatelessWidget {
  const PhoneNumberFormField(
      {super.key, required this.controller, this.validator});

  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
      ),
      validator: validator,
      keyboardType: TextInputType.phone,
    );
  }
}
