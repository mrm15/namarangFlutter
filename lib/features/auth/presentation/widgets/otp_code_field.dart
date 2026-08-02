import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart' as pkg;
import 'package:namarang/core/constants/app_colors.dart';

/// ویجت اختصاصی فیلد OTP، دور بسته‌ی flutter_otp_text_field رو می‌پیچه
/// و استایل برند رو روش اعمال می‌کنه.
///
/// نکته: اسمش رو OtpCodeField گذاشتیم (نه OtpTextField) که با کلاس
/// خودِ پکیج تداخل اسمی پیدا نکنه.
class OtpCodeField extends StatelessWidget {
  const OtpCodeField({
    super.key,
    required this.onCodeChanged,
    required this.onSubmit,
    this.numberOfFields = 4,
  });

  final int numberOfFields;
  final ValueChanged<String> onCodeChanged;
  final ValueChanged<String> onSubmit;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // خونه‌های کد همیشه چپ‌به‌راست چیده بشن، حتی تو صفحات فارسی
      textDirection: TextDirection.ltr,
      child: pkg.OtpTextField(
        numberOfFields: numberOfFields,
        fieldWidth: 56,
        borderWidth: 1.5,
        showFieldAsBox: true,
        borderRadius: BorderRadius.circular(14),
        borderColor: AppColors.border,
        enabledBorderColor: AppColors.border,
        focusedBorderColor: AppColors.primary,
        cursorColor: AppColors.primary,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        keyboardType: TextInputType.number,
        onCodeChanged: onCodeChanged,
        onSubmit: (code) => onSubmit(code),
      ),
    );
  }
}
