import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

enum AppLoadingOverlayStyle { blocking, subtle }

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = 28,
    this.strokeWidth = 2.5,
    this.color = AppColors.primary,
  });

  final double size;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(strokeWidth: strokeWidth, color: color),
    );
  }
}

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppLoader(size: 34, strokeWidth: 3));
  }
}

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loaderColor = AppColors.primary,
    this.barrierColor = const Color(0x52000000),
    this.style = AppLoadingOverlayStyle.blocking,
  });

  final bool isLoading;
  final Widget child;
  final Color loaderColor;
  final Color barrierColor;
  final AppLoadingOverlayStyle style;

  @override
  Widget build(BuildContext context) {
    if (style == AppLoadingOverlayStyle.subtle) {
      return Stack(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: isLoading ? 0.68 : 1,
            child: AbsorbPointer(absorbing: isLoading, child: child),
          ),
          if (isLoading)
            Positioned(
              top: 0,
              left: 16,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  minHeight: 3,
                  color: loaderColor,
                  backgroundColor: loaderColor.withValues(alpha: 0.12),
                ),
              ),
            ),
        ],
      );
    }

    return Stack(
      children: [
        AbsorbPointer(absorbing: isLoading, child: child),
        if (isLoading) ...[
          Positioned.fill(child: ColoredBox(color: barrierColor)),
          Positioned.fill(
            child: Center(
              child: Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x24000000),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: AppLoader(color: loaderColor),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
