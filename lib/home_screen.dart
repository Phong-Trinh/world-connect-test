import 'package:flutter/material.dart';
import 'package:world_connect_test/route.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  static const String routeName = 'homeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: IconButton(
                onPressed: () {
                  AppRoutes.navigateToUserProfileScreen(context);
                },
                icon: const Icon(Icons.person),
                iconSize: 48,
              ),
            ),
            const Text(
              'User Profile',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                AppRoutes.navigateToPostScreen(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.post_add),
                    SizedBox(width: 8),
                    Text(
                      'Go to Post',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
