import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/feedback/presentation/pages/feedback_page.dart';

Widget _wrap(Widget child) => MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(body: child),
    );

// TextFormField order: 0=name, 1=subject, 2=description
Future<void> _selectType(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pump();
}

Future<void> _fillRequiredFields(
  WidgetTester tester, {
  String subject = 'Assunto de teste',
  String description = 'Descrição de teste detalhada',
}) async {
  await tester.enterText(find.byType(TextFormField).at(1), subject);
  await tester.pump();
  await tester.enterText(find.byType(TextFormField).at(2), description);
  await tester.pump();
}

Future<void> _tapSubmit(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Enviar'));
  await tester.pump();
  await tester.tap(find.text('Enviar'));
  await tester.pumpAndSettle();
}

FilledButton _submitButton(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byType(FilledButton).first);

void main() {
  group('FeedbackPage', () {
    group('initial state', () {
      testWidgets('renders header title', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        expect(find.text('Reportar Bug / Sugestões'), findsWidgets);
      });

      testWidgets('renders both type cards', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        expect(find.text('Reportar Bug'), findsOneWidget);
        expect(find.text('Sugerir Melhoria'), findsOneWidget);
      });

      testWidgets('renders three form fields', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        expect(find.byType(TextFormField), findsNWidgets(3));
      });

      testWidgets('submit button is disabled initially', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await tester.ensureVisible(find.byType(FilledButton).first);
        expect(_submitButton(tester).onPressed, isNull);
      });
    });

    group('type selection', () {
      testWidgets('submit stays disabled after only selecting type', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await _selectType(tester, 'Reportar Bug');
        await tester.ensureVisible(find.byType(FilledButton).first);
        expect(_submitButton(tester).onPressed, isNull);
      });

      testWidgets('submit stays disabled after only filling description', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await tester.enterText(find.byType(TextFormField).at(2), 'Descrição');
        await tester.pump();
        await tester.ensureVisible(find.byType(FilledButton).first);
        expect(_submitButton(tester).onPressed, isNull);
      });

      testWidgets('submit enabled when type + description are filled', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await _selectType(tester, 'Reportar Bug');
        await tester.enterText(find.byType(TextFormField).at(2), 'Descrição preenchida');
        await tester.pump();
        await tester.ensureVisible(find.byType(FilledButton).first);
        expect(_submitButton(tester).onPressed, isNotNull);
      });

      testWidgets('sugerir melhoria type also enables submit', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await _selectType(tester, 'Sugerir Melhoria');
        await tester.enterText(find.byType(TextFormField).at(2), 'Sugestão');
        await tester.pump();
        await tester.ensureVisible(find.byType(FilledButton).first);
        expect(_submitButton(tester).onPressed, isNotNull);
      });
    });

    group('form validation', () {
      testWidgets('does not show dialog when subject is empty', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await _selectType(tester, 'Reportar Bug');
        await tester.enterText(find.byType(TextFormField).at(2), 'Descrição');
        await tester.pump();
        await _tapSubmit(tester);
        expect(find.text('Obrigado pelo feedback!'), findsNothing);
        expect(find.text('Informe o assunto'), findsOneWidget);
      });

      testWidgets('name field is optional — form submits without it', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await _selectType(tester, 'Reportar Bug');
        await _fillRequiredFields(tester);
        await _tapSubmit(tester);
        expect(find.text('Obrigado pelo feedback!'), findsOneWidget);
      });
    });

    group('submit — bug flow', () {
      testWidgets('shows success dialog with bug message', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await _selectType(tester, 'Reportar Bug');
        await _fillRequiredFields(tester);
        await _tapSubmit(tester);
        expect(find.text('Obrigado pelo feedback!'), findsOneWidget);
        expect(
          find.text('Seu reporte foi recebido. Vamos analisar e corrigir o problema.'),
          findsOneWidget,
        );
      });

      testWidgets('does not show suggestion message in bug dialog', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await _selectType(tester, 'Reportar Bug');
        await _fillRequiredFields(tester);
        await _tapSubmit(tester);
        expect(
          find.text('Sua sugestão foi recebida. Adoramos ouvir ideias novas!'),
          findsNothing,
        );
      });
    });

    group('submit — suggestion flow', () {
      testWidgets('shows success dialog with suggestion message', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await _selectType(tester, 'Sugerir Melhoria');
        await _fillRequiredFields(tester);
        await _tapSubmit(tester);
        expect(find.text('Obrigado pelo feedback!'), findsOneWidget);
        expect(
          find.text('Sua sugestão foi recebida. Adoramos ouvir ideias novas!'),
          findsOneWidget,
        );
      });
    });

    group('post-submit reset', () {
      testWidgets('closing dialog resets form — submit disabled again', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await _selectType(tester, 'Reportar Bug');
        await _fillRequiredFields(tester);
        await _tapSubmit(tester);

        await tester.tap(find.text('Fechar'));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byType(FilledButton).first);
        expect(_submitButton(tester).onPressed, isNull);
      });

      testWidgets('closing dialog dismisses it from screen', (tester) async {
        await tester.pumpWidget(_wrap(const FeedbackPage()));
        await _selectType(tester, 'Sugerir Melhoria');
        await _fillRequiredFields(tester);
        await _tapSubmit(tester);
        expect(find.text('Obrigado pelo feedback!'), findsOneWidget);

        await tester.tap(find.text('Fechar'));
        await tester.pumpAndSettle();
        expect(find.text('Obrigado pelo feedback!'), findsNothing);
      });
    });
  });
}
