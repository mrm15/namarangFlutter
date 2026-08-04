import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('================ HOME PAGE ================');

    return const Scaffold(body: Center(child: Text('HOME')));
  }
}
