import 'package:flutter/material.dart';
import 'package:post_list/post_list.dart';
import 'package:sign_up/sign_up.dart';
import 'package:sign_in/sign_in.dart';
import 'package:create_post/create_post.dart';
import 'package:update_profile/update_profile.dart';
import 'package:world_connect_test/home_screen.dart';

class AppRoutes {
  static const String noConnectionRoute = '/noConnection';
  static const String landingRoute = '/landing';
  static const String homeRoute = HomeScreen.routeName;
  static const String signupRoute = SignUpScreen.routeName;
  static const String signinRoute = LoginScreen.routeName;
  static const String userProfileRoute = UserProfileScreen.routeName;
  static const String postRoute = PostScreen.routName;
  static const String createPostRoute = CreatePostScreen.routeName;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case userProfileRoute:
        return MaterialPageRoute(builder: (_) => const UserProfileScreen());
      case createPostRoute:
        return MaterialPageRoute(
            builder: (_) => CreatePostScreen(onCreatePostSuccess: () {
                  Navigator.pop(_, PostScreenStatus.postCreated);
                }));
      case postRoute:
        return MaterialPageRoute(
            builder: (_) => PostScreen(
                onCreatePostScreenNavigated: () =>
                    navigateToCreatePostScreen(_)));
      case '/':
        return MaterialPageRoute(
          builder: (context) => LoginScreen(
            onSignUpLinkPressed: () {
              navigateToSignUpScreen(context);
            },
            onLoginSuccess: () {
              navigateToHomeScreen(context);
            },
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Error: Route not found!'),
            ),
          ),
        );
    }
  }

  static void navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(homeRoute);
  }

  static void navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).pushNamed(signupRoute);
  }

  static void navigateToUserProfileScreen(BuildContext context) {
    Navigator.of(context).pushNamed(userProfileRoute);
  }

  static void navigateToPostScreen(BuildContext context) {
    Navigator.of(context).pushNamed(postRoute);
  }

  static Future<PostScreenStatus> navigateToCreatePostScreen(
      BuildContext context) async {
    final t = await Navigator.of(context).pushNamed(createPostRoute);
    return t as PostScreenStatus;
  }
}
