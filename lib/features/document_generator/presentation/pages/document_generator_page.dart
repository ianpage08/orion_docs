import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/document_providers.dart';
import '../widgets/dynamic_form_builder.dart';
import '../widgets/preview_panel.dart';
import '../widgets/split_screen_container.dart';
import '../widgets/template_not_available_widget.dart';
import '../../../sidebar/presentation/controllers/sidebar_controller.dart';

class DocumentGeneratorPage extends ConsumerWidget {
  const DocumentGeneratorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(sidebarControllerProvider).activeItemId;
    final documentType = ref.watch(selectedDocumentTypeProvider);

    // Bridge: when a template loads successfully, push into formStateProvider
    if (documentType != null) {
      ref.listen(documentTemplateProvider(documentType), (_, next) {
        next.whenData(
          (doc) => ref.read(formStateProvider.notifier).loadDocument(doc),
        );
      });
    }

    // No sidebar item selected
    if (activeId == null) {
      return const _EmptyState();
    }

    // Sidebar item selected but no template available
    if (documentType == null) {
      return const TemplateNotAvailableWidget();
    }

    // Template available — show split screen
    return const SplitScreenContainer(
      formPanel: DynamicFormBuilder(),
      previewPanel: PreviewPanel(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_stories_rounded,
            size: 52,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'Selecione um documento',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}
