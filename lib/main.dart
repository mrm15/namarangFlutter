import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/router.dart';
import 'core/di/locator.dart';
import 'core/session/session_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  final session = locator<SessionController>();
  runApp(NamrangApp(router: AppRouter.create(session)));
}
