import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/nav_item.dart';
import '../controllers/sidebar_controller.dart';

class SidebarItemWidget extends ConsumerStatefulWidget {
  final NavItem item;
  final bool isCollapsed;

  const SidebarItemWidget({
    super.key,
    required this.item,
    required this.isCollapsed,
  });

  @override
  ConsumerState<SidebarItemWidget> createState() => _SidebarItemWidgetState();
}

class _SidebarItemWidgetState extends ConsumerState<SidebarItemWidget> {
  bool _isHovered = false;

  void _select() =>
      ref.read(sidebarControllerProvider.notifier).selectItem(widget.item.id);

  @override
  Widget build(BuildContext context) {
    final isActive =
        ref.watch(sidebarControllerProvider).activeItemId == widget.item.id;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isActive
        ? (isDark ? AppColors.activeItemBg : AppColors.lightActiveItemBg)
        : _isHovered
            ? (isDark ? AppColors.hoverItemBg : AppColors.lightHoverItemBg)
            : Colors.transparent;

    return Semantics(
      button: true,
      label: widget.item.label,
      selected: isActive,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (e) {
          if (e is KeyDownEvent &&
              e.logicalKey == LogicalKeyboardKey.enter) {
            _select();
          }
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: _select,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 2),
              child: Row(
                children: [
                  // Left accent indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 3,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isActive
                          ? (isDark
                              ? AppColors.textActive
                              : AppColors.lightTextActive)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm + 2),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.itemRadius),
                        color: bgColor,
                      ),
                      child: widget.isCollapsed
                          ? Center(
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive
                                      ? (isDark
                                          ? AppColors.textActive
                                          : AppColors.lightTextActive)
                                      : (isDark
                                          ? AppColors.textMuted
                                          : AppColors.lightTextMuted),
                                ),
                              ),
                            )
                          : Text(
                              widget.item.label,
                              style: AppTypography.body.copyWith(
                                color: isActive
                                    ? (isDark
                                        ? AppColors.textActive
                                        : AppColors.lightTextActive)
                                    : (isDark
                                        ? AppColors.textSecondary
                                        : AppColors.lightTextSecondary),
                                fontWeight: isActive
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
