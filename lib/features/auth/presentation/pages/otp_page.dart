import 'package:flutter/material.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('کد تایید')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'کد ارسال شده به',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(phoneNumber, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 32),
            const TextField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(hintText: 'کد تایید'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('تایید'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
