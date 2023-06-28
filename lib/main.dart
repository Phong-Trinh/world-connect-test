import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:world_connect_test/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:world_connect_test/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_theme.dart';
import 'route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(MultiRepositoryProvider(providers: [
    RepositoryProvider<UserRepository>(create: (context) => UserRepository()),
    RepositoryProvider<PostRepository>(create: (context) => PostRepository())
  ], child: const AppView()));
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final customTheme = CustomTheme(constraints);
      return MaterialApp(
        initialRoute: '/',
        onGenerateRoute: AppRoutes.generateRoute,
        title: 'Sample App',
        theme: ThemeData(
            elevatedButtonTheme: customTheme.elevatedButtonTheme(),
            outlinedButtonTheme: customTheme.outlinedButtonTheme(),
            textButtonTheme: customTheme.textButtonTheme(),
            dividerTheme: customTheme.dividerTheme(),
            hoverColor: kPrimaryPurple,
            focusColor: kPrimaryPurple,
            tabBarTheme: const TabBarTheme(
                labelColor: kPrimaryPurple,
                unselectedLabelColor: kTextColorAccent,
                dividerColor: kPrimaryPurple,
                indicatorColor: kPrimaryPurple),
            colorScheme: ThemeData()
                .colorScheme
                .copyWith(primary: kPrimaryPurple, background: kPrimaryPurple),
            appBarTheme: const AppBarTheme(backgroundColor: kPrimaryPurple),
            primaryColor: kPrimaryPurple),
      );
    });
  }
}
