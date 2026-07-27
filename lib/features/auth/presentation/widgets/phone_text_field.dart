import 'package:flutter/material.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      maxLength: 11,
      decoration: const InputDecoration(
        labelText: 'شماره موبایل',
        hintText: '09123456789',
        counterText: '',
      ),
      validator: (value) {
        final phone = value?.trim() ?? '';

        if (phone.isEmpty) {
          return 'شماره موبایل را وارد کنید';
        }

        if (!RegExp(r'^09\d{9}$').hasMatch(phone)) {
          return 'شماره موبایل معتبر نیست';
        }

        return null;
      },
    );
  }
}
