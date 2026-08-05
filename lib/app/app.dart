import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme.dart';

class NamrangApp extends StatelessWidget {
  const NamrangApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
