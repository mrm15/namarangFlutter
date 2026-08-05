import 'package:flutter/material.dart';
import 'package:namarang/core/constants/app_strings.dart';
import 'package:namarang/core/widgets/app_loader.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.onPressed,
    required this.loading,
  });

  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const AppLoader(size: 22, color: Colors.white)
            : const Text(
                AppStrings.btnLoginLabel,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
      ),
    );
  }
}
