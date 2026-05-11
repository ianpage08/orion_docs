import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/feedback/presentation/widgets/feedback_success_dialog.dart';

Widget _wrap(Widget child) => MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  group('FeedbackSuccessDialog', () {
    testWidgets('shows thank you title in both variants', (tester) async {
      await tester.pumpWidget(_wrap(const FeedbackSuccessDialog(isBug: true)));
      expect(find.text('Obrigado pelo feedback!'), findsOneWidget);
    });

    testWidgets('shows bug message when isBug is true', (tester) async {
      await tester.pumpWidget(_wrap(const FeedbackSuccessDialog(isBug: true)));
      expect(
        find.text('Seu reporte foi recebido. Vamos analisar e corrigir o problema.'),
        findsOneWidget,
      );
    });

    testWidgets('shows suggestion message when isBug is false', (tester) async {
      await tester.pumpWidget(_wrap(const FeedbackSuccessDialog(isBug: false)));
      expect(
        find.text('Sua sugestão foi recebida. Adoramos ouvir ideias novas!'),
        findsOneWidget,
      );
    });

    testWidgets('has a close button', (tester) async {
      await tester.pumpWidget(_wrap(const FeedbackSuccessDialog(isBug: true)));
      expect(find.text('Fechar'), findsOneWidget);
    });

    testWidgets('has check_circle_outline icon', (tester) async {
      await tester.pumpWidget(_wrap(const FeedbackSuccessDialog(isBug: false)));
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('bug and suggestion show different messages', (tester) async {
      await tester.pumpWidget(_wrap(const FeedbackSuccessDialog(isBug: true)));
      final bugMessage = 'Seu reporte foi recebido. Vamos analisar e corrigir o problema.';
      expect(find.text(bugMessage), findsOneWidget);

      await tester.pumpWidget(_wrap(const FeedbackSuccessDialog(isBug: false)));
      final suggestionMessage = 'Sua sugestão foi recebida. Adoramos ouvir ideias novas!';
      expect(find.text(suggestionMessage), findsOneWidget);
    });
  });
}
