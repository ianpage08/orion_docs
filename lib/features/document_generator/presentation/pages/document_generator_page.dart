import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/document_providers.dart';
import '../widgets/dynamic_form_builder.dart';
import '../widgets/preview_panel.dart';
import '../widgets/split_screen_container.dart';
import '../widgets/template_not_available_widget.dart';
import '../../../sidebar/presentation/controllers/sidebar_controller.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../feedback/presentation/pages/feedback_page.dart';

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

    // No sidebar item selected — show Command Center
    if (activeId == null) {
      return const HomeScreen();
    }

    if (activeId == 'feedback') {
      return const FeedbackPage();
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
