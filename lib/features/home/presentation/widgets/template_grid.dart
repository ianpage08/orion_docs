import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/home_providers.dart';
import 'template_card.dart';

class TemplateGrid extends ConsumerWidget {
  const TemplateGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(documentTemplatesProvider);

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.crossAxisExtent > 900 ? 3 : 2;
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: 1.8,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
            ),
            itemCount: templates.length,
            itemBuilder: (_, i) => TemplateCard(template: templates[i]),
          ),
        );
      },
    );
  }
}
