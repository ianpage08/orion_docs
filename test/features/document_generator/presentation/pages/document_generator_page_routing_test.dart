import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/document_generator/domain/entities/document.dart';
import 'package:orion_docs/features/document_generator/domain/entities/document_type.dart';
import 'package:orion_docs/features/document_generator/presentation/pages/document_generator_page.dart';
import 'package:orion_docs/features/document_generator/presentation/providers/document_providers.dart';
import 'package:orion_docs/features/document_generator/presentation/widgets/template_not_available_widget.dart';
import 'package:orion_docs/features/feedback/presentation/pages/feedback_page.dart';
import 'package:orion_docs/features/home/presentation/pages/home_screen.dart';
import 'package:orion_docs/features/sidebar/presentation/controllers/sidebar_controller.dart';

// ── Doubles ───────────────────────────────────────────────────────────────────

class _SidebarWithId extends SidebarController {
  final String? id;
  _SidebarWithId(this.id);

  @override
  SidebarState build() => SidebarState(activeItemId: id);
}

// ── Builders ──────────────────────────────────────────────────────────────────

Widget _buildWithActiveId(String? activeId) => ProviderScope(
      overrides: [
        sidebarControllerProvider.overrideWith(() => _SidebarWithId(activeId)),
      ],
      child: const MaterialApp(
        home: Scaffold(body: DocumentGeneratorPage()),
      ),
    );

/// Builder que também controla o resultado do [documentTemplateProvider].
Widget _buildWithTemplate(
  String activeId, {
  required Future<Document> Function() templateFn,
}) =>
    ProviderScope(
      overrides: [
        sidebarControllerProvider.overrideWith(() => _SidebarWithId(activeId)),
        documentTemplateProvider.overrideWith((ref, _) => templateFn()),
      ],
      child: const MaterialApp(
        home: Scaffold(body: DocumentGeneratorPage()),
      ),
    );

Document _fakeDoc() => const Document(
      type: DocumentType.contratoAluguel,
      title: 'Contrato Teste',
      fields: [],
      templateText: '',
    );

// ── Testes ────────────────────────────────────────────────────────────────────

void main() {
  group('DocumentGeneratorPage', () {
    // ── Roteamento estático ───────────────────────────────────────────────────

    group('roteamento', () {
      testWidgets('mostra HomeScreen quando nenhum item está selecionado', (tester) async {
        await tester.pumpWidget(_buildWithActiveId(null));
        await tester.pump();
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('mostra FeedbackPage quando activeId é "feedback"', (tester) async {
        await tester.pumpWidget(_buildWithActiveId('feedback'));
        await tester.pump();
        expect(find.byType(FeedbackPage), findsOneWidget);
      });

      testWidgets('FeedbackPage exibe os cards de tipo', (tester) async {
        await tester.pumpWidget(_buildWithActiveId('feedback'));
        await tester.pump();
        expect(find.text('Reportar Bug'), findsOneWidget);
        expect(find.text('Sugerir Melhoria'), findsOneWidget);
      });

      testWidgets('mostra TemplateNotAvailableWidget para ID sem mapeamento', (tester) async {
        await tester.pumpWidget(_buildWithActiveId('id_sem_template'));
        await tester.pump();
        expect(find.byType(TemplateNotAvailableWidget), findsOneWidget);
      });

      testWidgets('não mostra FeedbackPage para IDs de documento', (tester) async {
        await tester.pumpWidget(_buildWithActiveId('recibo_simples'));
        await tester.pump();
        expect(find.byType(FeedbackPage), findsNothing);
      });
    });

    // ── Estado de loading ─────────────────────────────────────────────────────

    group('estado de loading', () {
      testWidgets('exibe CircularProgressIndicator enquanto o template carrega', (tester) async {
        await tester.pumpWidget(
          _buildWithTemplate(
            'contrato_aluguel',
            templateFn: () => Completer<Document>().future,
          ),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Erro ao carregar o modelo'), findsNothing);
      });

      testWidgets('não exibe conteúdo do formulário durante o loading', (tester) async {
        await tester.pumpWidget(
          _buildWithTemplate(
            'contrato_aluguel',
            templateFn: () => Completer<Document>().future,
          ),
        );
        await tester.pump();

        expect(find.text('Gerador de Arquivos'), findsNothing);
      });
    });

    // ── Estado de erro ────────────────────────────────────────────────────────

    group('estado de erro', () {
      testWidgets('exibe mensagem de erro quando o template falha', (tester) async {
        await tester.pumpWidget(
          _buildWithTemplate(
            'contrato_aluguel',
            templateFn: () => Future.error(Exception('falha')),
          ),
        );
        await tester.pump(); // monta widget em loading
        await tester.pump(); // future falha → error state

        expect(find.text('Erro ao carregar o modelo'), findsOneWidget);
      });

      testWidgets('exibe botão de tentar novamente', (tester) async {
        await tester.pumpWidget(
          _buildWithTemplate(
            'contrato_aluguel',
            templateFn: () => Future.error(Exception('falha')),
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(find.text('Tentar novamente'), findsOneWidget);
      });

      testWidgets('botão de retry é tapeável sem lançar exceção', (tester) async {
        await tester.pumpWidget(
          _buildWithTemplate(
            'contrato_aluguel',
            templateFn: () => Future.error(Exception('falha')),
          ),
        );
        await tester.pump();
        await tester.pump();

        await tester.tap(find.text('Tentar novamente'));
        await tester.pump();
        // Após retry o template ainda falha — mas não deve lançar exceção
        expect(tester.takeException(), isNull);
      });

      testWidgets('não exibe conteúdo do formulário no estado de erro', (tester) async {
        await tester.pumpWidget(
          _buildWithTemplate(
            'contrato_aluguel',
            templateFn: () => Future.error(Exception('falha')),
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(find.text('Gerador de Arquivos'), findsNothing);
      });
    });

    // ── Estado de dados (sucesso) ─────────────────────────────────────────────

    group('estado de dados', () {
      testWidgets('exibe o formulário quando o template carrega com sucesso', (tester) async {
        await tester.pumpWidget(
          _buildWithTemplate(
            'contrato_aluguel',
            templateFn: () async => _fakeDoc(),
          ),
        );
        await tester.pump(); // loading
        await tester.pump(); // template resolve → data

        expect(find.text('Gerador de Arquivos'), findsOneWidget);
      });

      testWidgets('não exibe CircularProgressIndicator após carregar', (tester) async {
        await tester.pumpWidget(
          _buildWithTemplate(
            'contrato_aluguel',
            templateFn: () async => _fakeDoc(),
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('não exibe mensagem de erro após carregar com sucesso', (tester) async {
        await tester.pumpWidget(
          _buildWithTemplate(
            'contrato_aluguel',
            templateFn: () async => _fakeDoc(),
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(find.text('Erro ao carregar o modelo'), findsNothing);
      });
    });
  });
}
