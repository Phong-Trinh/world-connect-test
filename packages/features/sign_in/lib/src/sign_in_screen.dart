import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in/src/sign_in_state.dart';
import 'package:user_repository/user_repository.dart';

import 'sign_in_cubit.dart';
import 'widgets/account_login.dart';
import 'widgets/google_login.dart';
import 'widgets/phone_number_login.dart';

typedef OnSignUpLinkPressed = void Function();
typedef OnLoginSuccess = void Function();

class LoginScreen extends StatelessWidget {
  const LoginScreen(
      {super.key,
      required this.onSignUpLinkPressed,
      required this.onLoginSuccess});

  static const String routeName = 'LoginScreen';
  final OnSignUpLinkPressed onSignUpLinkPressed;
  final OnLoginSuccess onLoginSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SigninCubit(
            userRepository: RepositoryProvider.of<UserRepository>(context)),
        child: LoginForm(
            onSignUpLinkPressed: onSignUpLinkPressed,
            onLoginSuccess: onLoginSuccess));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm(
      {super.key,
      required this.onSignUpLinkPressed,
      required this.onLoginSuccess});

  final OnSignUpLinkPressed onSignUpLinkPressed;
  final OnLoginSuccess onLoginSuccess;

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTab(IconData icon, String label) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocListener(
        listener: (context, state) {
          if (state is SigninSuccess) {
            widget.onLoginSuccess();
          } else if (state is SigninFail) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Login fail, please try again.. 🚨'),
              ));
          }
        },
        bloc: BlocProvider.of<SigninCubit>(context),
        child: Column(
          children: [
            TabBar(
              indicatorColor: Colors.transparent,
              controller: _tabController,
              tabs: [
                _buildTab(Icons.email, 'Account'),
                _buildTab(Icons.phone, 'Phone Number'),
                _buildTab(Icons.login, 'Google'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  EmailPasswordLogin(
                      onSignUpLinkPressed: widget.onSignUpLinkPressed),
                  const PhoneOTPLogin(),
                  const GoogleLogin(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
