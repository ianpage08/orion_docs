import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';

class FeedbackSuccessDialog extends StatelessWidget {
  final bool isBug;

  const FeedbackSuccessDialog({super.key, required this.isBug});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final message = isBug
        ? 'Seu reporte foi recebido. Vamos analisar e corrigir o problema.'
        : 'Sua sugestão foi recebida. Adoramos ouvir ideias novas!';

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: isDark ? AppColors.sidebarSurface : Colors.white,
          border: Border.all(
            color: isDark ? AppColors.sidebarBorder : AppColors.lightSidebarBorder,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.textActive.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.textActive,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Obrigado pelo feedback!',
              style: AppTypography.headline.copyWith(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTypography.body.copyWith(
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.textActive,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.itemRadius),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Fechar', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
