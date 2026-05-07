import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ProductivityWidget extends StatelessWidget {
  const ProductivityWidget({super.key});

  static const int _count = 5;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text.rich(
        TextSpan(
          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
          children: [
            const TextSpan(text: '📊  '),
            TextSpan(
              text: '$_count',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: ' documentos gerados este mês'),
          ],
        ),
      ),
    );
  }
}
