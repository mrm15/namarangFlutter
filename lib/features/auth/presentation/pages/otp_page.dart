import 'package:flutter/material.dart';
import 'package:namarang/core/constants/app_strings.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.otpTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.otpSentTo,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(phoneNumber, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 32),
            const TextField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(hintText: AppStrings.otpHint),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(AppStrings.otpVerifyButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
