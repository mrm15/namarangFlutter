import 'package:flutter/material.dart';
import 'package:namarang/core/constants/app_strings.dart';

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
        labelText: AppStrings.phoneNumberLabel,
        hintText: AppStrings.phoneNumberHint,
        counterText: '',
      ),
      validator: (value) {
        final phone = value?.trim() ?? '';

        if (phone.isEmpty) {
          return AppStrings.phoneNumberRequired;
        }

        if (!RegExp(r'^09\d{9}$').hasMatch(phone)) {
          return AppStrings.invalidPhoneNumber;
        }

        return null;
      },
    );
  }
}
