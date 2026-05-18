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

    if (activeId == null) return const HomeScreen();
    if (activeId == 'feedback') return const FeedbackPage();
    if (documentType == null) return const TemplateNotAvailableWidget();

    return ref.watch(formStateProvider(documentType)).when(
      loading: () => const _TemplateLoadingWidget(),
      error: (_, __) => _TemplateLoadErrorWidget(
        onRetry: () => ref.invalidate(documentTemplateProvider(documentType)),
      ),
      data: (_) => const SplitScreenContainer(
        formPanel: DynamicFormBuilder(),
        previewPanel: PreviewPanel(),
      ),
    );
  }
}

class _TemplateLoadingWidget extends StatelessWidget {
  const _TemplateLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF1E1E2E),
      child: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6666AA),
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class _TemplateLoadErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const _TemplateLoadErrorWidget({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF1E1E2E),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Color(0xFF884444),
            ),
            const SizedBox(height: 16),
            const Text(
              'Erro ao carregar o modelo',
              style: TextStyle(
                color: Color(0xFF888899),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Não foi possível carregar este documento.\nTente novamente ou reinicie o aplicativo.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF555566), fontSize: 13),
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
