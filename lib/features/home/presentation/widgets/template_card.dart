import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../sidebar/presentation/controllers/sidebar_controller.dart';
import '../providers/home_providers.dart';

class TemplateCard extends ConsumerStatefulWidget {
  final DocumentTemplate template;

  const TemplateCard({super.key, required this.template});

  @override
  ConsumerState<TemplateCard> createState() => _TemplateCardState();
}

class _TemplateCardState extends ConsumerState<TemplateCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _onTap() =>
      ref.read(sidebarControllerProvider.notifier).selectItem(widget.template.id);

  @override
  Widget build(BuildContext context) {
    final borderOpacity = _isHovered ? 0.45 : 0.15;

    return Semantics(
      label: widget.template.name,
      button: true,
      child: RepaintBoundary(
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : (_isHovered ? 1.01 : 1.0),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() {
              _isHovered = false;
              _isPressed = false;
            }),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: _onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                  border: Border.all(
                    color: AppColors.gradientStart
                        .withValues(alpha: borderOpacity),
                  ),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: ColoredBox(
                      color: AppColors.darkBg.withValues(alpha: 0.06),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.template.icon,
                              size: 28,
                              color: AppColors.textActive,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              widget.template.name,
                              style: AppTypography.title.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              widget.template.subtitle,
                              style: AppTypography.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
