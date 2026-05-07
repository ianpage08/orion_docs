import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../controllers/sidebar_controller.dart';
import 'sidebar_group.dart';
import 'sidebar_header.dart';

class AppSidebar extends ConsumerWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sidebarControllerProvider);
    final groups = ref.watch(sidebarGroupsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOutCubic,
      width: state.isCollapsed
          ? AppSpacing.sidebarCollapsed
          : AppSpacing.sidebarExpanded,
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.sidebarSurface
              : AppColors.lightSidebarSurface,
          border: Border(
            right: BorderSide(
              color: isDark
                  ? AppColors.sidebarBorder
                  : AppColors.lightSidebarBorder,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SidebarHeader(isCollapsed: state.isCollapsed),
            Divider(
              height: 1,
              color: isDark
                  ? AppColors.sidebarBorder
                  : AppColors.lightSidebarBorder,
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                itemCount: groups.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.xs),
                itemBuilder: (_, i) => SidebarGroupWidget(
                  key: ValueKey(groups[i].id),
                  group: groups[i],
                  isCollapsed: state.isCollapsed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
