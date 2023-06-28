import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../sign_in_cubit.dart';
import '../sign_in_state.dart';

class PhoneOTPLogin extends StatefulWidget {
  const PhoneOTPLogin({Key? key}) : super(key: key);

  @override
  PhoneOTPLoginState createState() => PhoneOTPLoginState();
}

class PhoneOTPLoginState extends State<PhoneOTPLogin> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOTP(SigninCubit cubit) {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = _phoneNumberController.text;

      cubit.sendOTP(phoneNumber);
    }
  }

  void _verifyPhoneNumber(SigninCubit cubit, String verificationId) {
    if (_formKey.currentState!.validate()) {
      final otp = _otpController.text;

      cubit.verifyPhoneNumber(verificationId: verificationId, otp: otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SigninCubit>.value(
      value: BlocProvider.of<SigninCubit>(context),
      child: BlocBuilder<SigninCubit, SigninState>(
        builder: (context, state) {
          final cubit = context.read<SigninCubit>();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PhoneNumberFormField(
                    controller: _phoneNumberController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  if (state is SigninOTPSent)
                    TextFormField(
                      controller: _otpController,
                      decoration: const InputDecoration(
                        labelText: 'OTP',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the OTP';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () => state is SigninOTPSent
                        ? _verifyPhoneNumber(cubit, state.verificationId)
                        : _sendOTP(cubit),
                    child: Text(
                        state is SigninOTPSent ? 'Verify OTP' : 'Send OTP'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
