import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/document_generator/presentation/pages/document_generator_page.dart';
import 'package:orion_docs/features/feedback/presentation/pages/feedback_page.dart';
import 'package:orion_docs/features/sidebar/presentation/controllers/sidebar_controller.dart';

class _SidebarWithId extends SidebarController {
  final String? id;
  _SidebarWithId(this.id);

  @override
  SidebarState build() => SidebarState(activeItemId: id);
}

Widget _buildWithActiveId(String? activeId) => ProviderScope(
      overrides: [
        sidebarControllerProvider
            .overrideWith(() => _SidebarWithId(activeId)),
      ],
      child: const MaterialApp(
        home: Scaffold(body: DocumentGeneratorPage()),
      ),
    );

void main() {
  group('DocumentGeneratorPage routing', () {
    testWidgets('shows FeedbackPage when activeId is feedback', (tester) async {
      await tester.pumpWidget(_buildWithActiveId('feedback'));
      await tester.pump();
      expect(find.byType(FeedbackPage), findsOneWidget);
    });

    testWidgets('FeedbackPage shows type selector cards', (tester) async {
      await tester.pumpWidget(_buildWithActiveId('feedback'));
      await tester.pump();
      expect(find.text('Reportar Bug'), findsOneWidget);
      expect(find.text('Sugerir Melhoria'), findsOneWidget);
    });

    testWidgets('does not show FeedbackPage for other item ids', (tester) async {
      await tester.pumpWidget(_buildWithActiveId('recibo_simples'));
      await tester.pump();
      expect(find.byType(FeedbackPage), findsNothing);
    });
  });
}
