import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/nav_group.dart';
import '../controllers/sidebar_controller.dart';
import 'sidebar_item.dart';

class SidebarGroupWidget extends ConsumerWidget {
  final NavGroup group;
  final bool isCollapsed;

  const SidebarGroupWidget({
    super.key,
    required this.group,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded =
        ref.watch(sidebarControllerProvider).expandedGroups.contains(group.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          button: true,
          label: '${group.label}, ${isExpanded ? 'recolher' : 'expandir'}',
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => ref
                  .read(sidebarControllerProvider.notifier)
                  .toggleGroup(group.id),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    if (!isCollapsed) ...[
                      Expanded(
                        child: Text(
                          group.label.toUpperCase(),
                          style: AppTypography.caption.copyWith(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: group.items
                .map(
                  (item) => SidebarItemWidget(
                    key: ValueKey(item.id),
                    item: item,
                    isCollapsed: isCollapsed,
                  ),
                )
                .toList(),
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 220),
          sizeCurve: Curves.easeInOutCubic,
        ),
      ],
    );
  }
}
