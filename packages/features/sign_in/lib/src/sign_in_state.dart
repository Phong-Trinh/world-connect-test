class SigninState {
  const SigninState();
}

class SigninInit extends SigninState {}

class SigninLoading extends SigninState {}

class SigninOTPSent extends SigninState {
  final String verificationId;

  SigninOTPSent(this.verificationId);
}

class SigninSuccess extends SigninState {}

class SigninFail extends SigninState {}
