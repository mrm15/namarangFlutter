import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:namarang/core/constants/app_colors.dart';
import 'package:namarang/core/constants/app_strings.dart';
import 'package:namarang/core/di/locator.dart';
import 'package:namarang/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:namarang/features/auth/presentation/cubit/auth_state.dart';
import 'package:namarang/features/auth/presentation/widgets/otp_code_field.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String _code = '';

  void _verify(BuildContext context, AuthState state) {
    if (_code.length != 4) return;
    if (state.isLoading) return;

    context.read<AuthCubit>().verifyOtp(
      phoneNumber: widget.phoneNumber,
      code: _code,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.authResponse != null) {
            context.go('/home');
          }

          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color(0xFFF4F6F9),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
              ),
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
                              const SizedBox(height: 12),
                              _OtpHeader(phoneNumber: widget.phoneNumber),
                              const SizedBox(height: 36),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 28,
                                  ),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      OtpCodeField(
                                        onCodeChanged: (code) =>
                                            setState(() => _code = code),
                                        onSubmit: (code) {
                                          _code = code;
                                          _verify(context, state);
                                        },
                                      ),
                                      const SizedBox(height: 26),
                                      SizedBox(
                                        height: 52,
                                        child: ElevatedButton(
                                          onPressed:
                                              (state.isLoading ||
                                                  _code.length != 4)
                                              ? null
                                              : () => _verify(context, state),
                                          child: state.isLoading
                                              ? const SizedBox(
                                                  width: 22,
                                                  height: 22,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                )
                                              : const Text(
                                                  AppStrings.otpVerifyButton,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Center(
                                        child: TextButton(
                                          onPressed: state.isLoading
                                              ? null
                                              : () {
                                                  // TODO: منطق ارسال مجدد کد
                                                },
                                          child: const Text(
                                            AppStrings.resendCode,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// آیکون تزئینی + عنوان + شماره موبایل بالای صفحه OTP
class _OtpHeader extends StatelessWidget {
  const _OtpHeader({required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 120,
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.10),
                  AppColors.primary.withValues(alpha: 0),
                ],
              ),
            ),
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(
                Icons.sms_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          AppStrings.otpTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text.rich(
            TextSpan(
              text: '${AppStrings.otpSentTo} ',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: phoneNumber,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
