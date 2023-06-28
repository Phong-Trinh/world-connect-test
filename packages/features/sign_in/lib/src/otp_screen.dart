import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Perform OTP verification logic here
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
