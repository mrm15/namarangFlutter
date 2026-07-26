import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class NamrangApp extends StatelessWidget {
  const NamrangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
