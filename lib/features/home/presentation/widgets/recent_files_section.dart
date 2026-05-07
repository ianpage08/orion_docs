import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/home_providers.dart';
import 'recent_file_tile.dart';

class RecentFilesSection extends ConsumerWidget {
  const RecentFilesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(recentFilesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RECENTES', style: AppTypography.caption),
        const SizedBox(height: AppSpacing.sm),
        Divider(
          color: AppColors.sidebarBorder,
          height: 1,
        ),
        const SizedBox(height: AppSpacing.xs),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: files.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
          itemBuilder: (context, i) => RecentFileTile(file: files[i]),
        ),
      ],
    );
  }
}
