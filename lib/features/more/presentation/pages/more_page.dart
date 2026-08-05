import 'package:flutter/material.dart';
import 'package:namarang/core/constants/app_strings.dart';

/// تب سوم — فعلاً خالی، بعداً محتوا اضافه می‌شود.
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text(AppStrings.comingSoon)));
  }
}
