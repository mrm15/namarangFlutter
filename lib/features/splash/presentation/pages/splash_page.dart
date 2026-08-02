import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:namarang/core/di/locator.dart';
import 'package:namarang/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:namarang/features/splash/presentation/cubit/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SplashCubit>()..initialize(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.isLoading) return;

          if (state.isLoggedIn) {
            context.go('/home');
          } else {
            context.go('/login');
          }
        },
        child: const Scaffold(body: Center(child: FlutterLogo(size: 120))),
      ),
    );
  }
}
