import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/work_status.dart';
import '../cubit/work_status_cubit.dart';
import '../cubit/work_status_state.dart';

class WorkStatusHeader extends StatelessWidget implements PreferredSizeWidget {
  const WorkStatusHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: AppColors.brandGradient),
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        AppStrings.driversSystem,
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<WorkStatusCubit, WorkStatusState>(
                  builder: (context, state) {
                    return _StatusPill(
                      state: state,
                      onTap: () => _showStatusSheet(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showStatusSheet(BuildContext context) {
    final cubit = context.read<WorkStatusCubit>();
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          BlocProvider.value(value: cubit, child: const _WorkStatusSheet()),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.state, required this.onTap});

  final WorkStatusState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = state.status;
    final isReady = status == WorkStatus.ready;

    return Material(
      color: Colors.white.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: state.isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          constraints: const BoxConstraints(minWidth: 92),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.isLoading)
                const AppLoader(size: 14, strokeWidth: 2, color: Colors.white70)
              else
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status == null
                        ? Colors.white38
                        : isReady
                        ? const Color(0xFF4ADE80)
                        : const Color(0xFFF87171),
                    boxShadow: isReady
                        ? const [
                            BoxShadow(color: Color(0x994ADE80), blurRadius: 7),
                          ]
                        : null,
                  ),
                ),
              const SizedBox(width: 7),
              Text(
                state.isLoading
                    ? AppStrings.workStatusLoading
                    : status == null
                    ? AppStrings.workStatusUnknown
                    : isReady
                    ? AppStrings.workStatusReady
                    : AppStrings.workStatusInactive,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 3),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkStatusSheet extends StatelessWidget {
  const _WorkStatusSheet();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: BlocBuilder<WorkStatusCubit, WorkStatusState>(
          builder: (context, state) {
            return AppLoadingOverlay(
              isLoading: state.isUpdating,
              style: AppLoadingOverlayStyle.subtle,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7DCE2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.workStatusTitle,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              AppStrings.workStatusDescription,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: state.isUpdating
                            ? null
                            : () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _StatusOption(
                    status: WorkStatus.ready,
                    title: AppStrings.readyForWorkTitle,
                    subtitle: AppStrings.readyForWorkSubtitle,
                    color: const Color(0xFF22C55E),
                    selected: state.status == WorkStatus.ready,
                    loading: state.isUpdating,
                  ),
                  const SizedBox(height: 10),
                  _StatusOption(
                    status: WorkStatus.notReady,
                    title: AppStrings.inactiveWorkTitle,
                    subtitle: AppStrings.inactiveWorkSubtitle,
                    color: const Color(0xFFEF4444),
                    selected: state.status == WorkStatus.notReady,
                    loading: state.isUpdating,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({
    required this.status,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.selected,
    required this.loading,
  });

  final WorkStatus status;
  final String title;
  final String subtitle;
  final Color color;
  final bool selected;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? color.withValues(alpha: 0.08) : const Color(0xFFF8F9FB),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: loading || selected
            ? null
            : () async {
                final changed = await context.read<WorkStatusCubit>().update(
                  status,
                );
                if (changed && context.mounted) Navigator.of(context).pop();
              },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? color.withValues(alpha: 0.35)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: selected ? color : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (loading && !selected)
                const SizedBox.shrink()
              else if (selected)
                Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: color, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.active,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
