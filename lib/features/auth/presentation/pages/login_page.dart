import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:namarang/core/constants/app_colors.dart';
import 'package:namarang/core/constants/app_strings.dart';
import 'package:namarang/core/constants/app_keys.dart';
import 'package:namarang/gen/assets.gen.dart';

import '../../../../core/di/locator.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/login_button.dart';
import '../widgets/phone_text_field.dart';
import 'dart:developer' as developer;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          developer.log('SERVICE STARTED', name: 'NAMRANG');

          if (state is OtpSent) {
            context.push(
              Uri(
                path: '/otp',
                queryParameters: {
                  AppKeys.phoneQuery: phoneController.text.trim(),
                },
              ).toString(),
            );
          }

          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F6F9),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 32),

                            // --- لوگوی برند با هاله‌ی ملایم پشت آن ---
                            Center(
                              child: Container(
                                width: 160,
                                height: 160,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.primary.withValues(alpha: 0.08),
                                      AppColors.primary.withValues(alpha: 0),
                                    ],
                                  ),
                                ),
                                child: Assets.images.namarangLogo.svg(
                                  height: 88,
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // --- عنوان خوش‌آمدگویی ---
                            const Text(
                              AppStrings.loginWelcomeTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              AppStrings.loginWelcomeSubtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            const SizedBox(height: 36),

                            // --- کارت فرم ورود ---
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 30,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Text(
                                          AppStrings.phoneNumberLabel,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        PhoneTextField(
                                          controller: phoneController,
                                        ),
                                        const SizedBox(height: 22),
                                        SizedBox(
                                          height: 52,
                                          child: LoginButton(
                                            loading: state.isLoading,
                                            onPressed: () {
                                              if (!_formKey.currentState!
                                                  .validate()) {
                                                return;
                                              }

                                              context.read<AuthCubit>().sendOtp(
                                                phoneController.text.trim(),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(),
                            const SizedBox(height: 24),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                AppStrings.loginTermsText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
