import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/sidebar_controller.dart';

class SidebarHeader extends ConsumerWidget {
  final bool isCollapsed;

  const SidebarHeader({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? AppSpacing.xs : AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          _Logo(isDark: isDark),
          if (!isCollapsed) ...[
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Orion Docs',
                style: AppTypography.title.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ] else
            const Spacer(),
          _CollapseButton(isCollapsed: isCollapsed),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final bool isDark;
  const _Logo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: isDark
            ? [BoxShadow(color: AppColors.neonGlow, blurRadius: 12)]
            : null,
      ),
      child: const Icon(Icons.auto_stories_rounded,
          color: Colors.white, size: 17),
    );
  }
}

class _CollapseButton extends ConsumerWidget {
  final bool isCollapsed;
  const _CollapseButton({required this.isCollapsed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: isCollapsed ? 'Expandir menu' : 'Recolher menu',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () =>
              ref.read(sidebarControllerProvider.notifier).toggleCollapse(),
          child: AnimatedRotation(
            turns: isCollapsed ? 0.5 : 0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCubic,
            child: Icon(
              Icons.chevron_left_rounded,
              size: 20,
              color: isDark ? AppColors.textMuted : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
