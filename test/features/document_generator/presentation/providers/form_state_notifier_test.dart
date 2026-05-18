import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/document_generator/domain/entities/document.dart';
import 'package:orion_docs/features/document_generator/domain/entities/document_type.dart';
import 'package:orion_docs/features/document_generator/domain/entities/field.dart';
import 'package:orion_docs/features/document_generator/presentation/providers/document_providers.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

Document _doc({List<Field> fields = const []}) => Document(
      type: DocumentType.contratoAluguel,
      title: 'Contrato Teste',
      fields: fields,
      templateText: '',
    );

Field _field(String id, {String value = ''}) => Field(
      id: id,
      label: 'Campo $id',
      type: FieldType.text,
      required: false,
      value: value,
    );

/// Cria um container com override do template e mantém o provider ativo.
/// Retorna o container e a subscription (para tearDown via [addTearDown]).
ProviderContainer _makeContainer(
  Future<Document> Function() templateFn,
) {
  final container = ProviderContainer(overrides: [
    documentTemplateProvider.overrideWith((ref, _) => templateFn()),
  ]);
  return container;
}

/// Espera o provider sair do estado de loading e retorna o novo estado.
Future<AsyncValue<Document>> _awaitState(
  ProviderContainer container,
  DocumentType type,
) {
  final completer = Completer<AsyncValue<Document>>();
  container.listen<AsyncValue<Document>>(
    formStateProvider(type),
    (_, next) {
      if (!next.isLoading && !completer.isCompleted) completer.complete(next);
    },
    fireImmediately: true,
  );
  return completer.future;
}

// ── Testes ────────────────────────────────────────────────────────────────────

void main() {
  const type = DocumentType.contratoAluguel;

  group('FormStateNotifier', () {
    // ── Estado inicial ────────────────────────────────────────────────────────

    group('estado inicial', () {
      test('começa em AsyncLoading enquanto o template carrega', () {
        final container = _makeContainer(() => Completer<Document>().future);
        addTearDown(container.dispose);

        final sub = container.listen(formStateProvider(type), (_, __) {});
        addTearDown(sub.close);

        expect(
          container.read(formStateProvider(type)),
          isA<AsyncLoading<Document>>(),
        );
      });
    });

    // ── Carregamento bem-sucedido ─────────────────────────────────────────────

    group('carregamento com sucesso', () {
      test('transiciona para AsyncData quando o template resolve', () async {
        final doc = _doc(fields: [_field('nome')]);
        final container = _makeContainer(() async => doc);
        addTearDown(container.dispose);

        final state = await _awaitState(container, type);

        expect(state, isA<AsyncData<Document>>());
        expect(state.value, doc);
      });

      test('AsyncData contém os campos do template original', () async {
        final doc = _doc(fields: [_field('nome'), _field('cpf')]);
        final container = _makeContainer(() async => doc);
        addTearDown(container.dispose);

        final state = await _awaitState(container, type);
        expect(state.value!.fields.map((f) => f.id), containsAll(['nome', 'cpf']));
      });
    });

    // ── Erro de carregamento ──────────────────────────────────────────────────

    group('carregamento com erro', () {
      test('transiciona para AsyncError quando o template falha', () async {
        final container = _makeContainer(
          () => Future.error(Exception('falha ao carregar')),
        );
        addTearDown(container.dispose);

        final state = await _awaitState(container, type);

        expect(state, isA<AsyncError<Document>>());
      });

      test('AsyncError preserva a exceção original', () async {
        final exception = Exception('mensagem de erro específica');
        final container = _makeContainer(() => Future.error(exception));
        addTearDown(container.dispose);

        final state = await _awaitState(container, type);

        expect(state.error, exception);
      });
    });

    // ── updateField ───────────────────────────────────────────────────────────

    group('updateField', () {
      late ProviderContainer container;

      setUp(() async {
        final doc = _doc(fields: [_field('nome'), _field('cpf')]);
        container = _makeContainer(() async => doc);
        await _awaitState(container, type);
      });

      tearDown(() => container.dispose());

      test('atualiza apenas o campo especificado', () {
        container
            .read(formStateProvider(type).notifier)
            .updateField('nome', 'João Silva');

        final fields = container.read(formStateProvider(type)).value!.fields;
        expect(fields.firstWhere((f) => f.id == 'nome').value, 'João Silva');
        expect(fields.firstWhere((f) => f.id == 'cpf').value, '');
      });

      test('múltiplas edições acumulam corretamente', () {
        container.read(formStateProvider(type).notifier).updateField('nome', 'João');
        container.read(formStateProvider(type).notifier).updateField('cpf', '123.456.789-00');

        final fields = container.read(formStateProvider(type)).value!.fields;
        expect(fields.firstWhere((f) => f.id == 'nome').value, 'João');
        expect(fields.firstWhere((f) => f.id == 'cpf').value, '123.456.789-00');
      });

      test('ID inexistente não altera o estado', () {
        final before = container.read(formStateProvider(type)).value!.fields;

        container
            .read(formStateProvider(type).notifier)
            .updateField('nao_existe', 'valor');

        final after = container.read(formStateProvider(type)).value!.fields;
        expect(
          after.map((f) => f.value),
          equals(before.map((f) => f.value)),
        );
      });

      test('é no-op quando ainda está carregando — não lança exceção', () {
        final loadingContainer = _makeContainer(
          () => Completer<Document>().future,
        );
        addTearDown(loadingContainer.dispose);
        final sub = loadingContainer.listen(formStateProvider(type), (_, __) {});
        addTearDown(sub.close);

        expect(
          () => loadingContainer
              .read(formStateProvider(type).notifier)
              .updateField('nome', 'João'),
          returnsNormally,
        );
        expect(
          loadingContainer.read(formStateProvider(type)),
          isA<AsyncLoading<Document>>(),
        );
      });
    });

    // ── reset ─────────────────────────────────────────────────────────────────

    group('reset', () {
      test('limpa todos os valores dos campos', () async {
        final doc = _doc(fields: [
          _field('nome', value: 'João'),
          _field('cpf', value: '123.456.789-00'),
        ]);
        final container = _makeContainer(() async => doc);
        addTearDown(container.dispose);
        await _awaitState(container, type);

        container.read(formStateProvider(type).notifier).reset();

        final fields = container.read(formStateProvider(type)).value!.fields;
        expect(fields.every((f) => f.value.isEmpty), isTrue);
      });

      test('preserva id, label e type dos campos após reset', () async {
        final doc = _doc(fields: [_field('nome', value: 'João')]);
        final container = _makeContainer(() async => doc);
        addTearDown(container.dispose);
        await _awaitState(container, type);

        container.read(formStateProvider(type).notifier).reset();

        final field = container.read(formStateProvider(type)).value!.fields.first;
        expect(field.id, 'nome');
        expect(field.label, 'Campo nome');
        expect(field.type, FieldType.text);
      });

      test('é no-op quando ainda está carregando — não lança exceção', () {
        final container = _makeContainer(() => Completer<Document>().future);
        addTearDown(container.dispose);
        container.listen(formStateProvider(type), (_, __) {});

        expect(
          () => container.read(formStateProvider(type).notifier).reset(),
          returnsNormally,
        );
      });
    });

    // ── Isolamento por DocumentType (family) ──────────────────────────────────

    group('isolamento por DocumentType', () {
      test('edições em um tipo não afetam outro tipo', () async {
        const typeA = DocumentType.contratoAluguel;
        const typeB = DocumentType.contratoCompraVenda;
        final doc = _doc(fields: [_field('nome')]);

        final container = _makeContainer(() async => doc);
        addTearDown(container.dispose);

        await _awaitState(container, typeA);
        await _awaitState(container, typeB);

        container
            .read(formStateProvider(typeA).notifier)
            .updateField('nome', 'Editado em A');

        expect(
          container.read(formStateProvider(typeA)).value!.fields.first.value,
          'Editado em A',
        );
        expect(
          container.read(formStateProvider(typeB)).value!.fields.first.value,
          '',
        );
      });

      test('reset em um tipo não afeta outro tipo', () async {
        const typeA = DocumentType.contratoAluguel;
        const typeB = DocumentType.contratoCompraVenda;
        final doc = _doc(fields: [_field('nome', value: 'Preenchido')]);

        final container = _makeContainer(() async => doc);
        addTearDown(container.dispose);

        await _awaitState(container, typeA);
        await _awaitState(container, typeB);

        container.read(formStateProvider(typeA).notifier).reset();

        expect(
          container.read(formStateProvider(typeA)).value!.fields.first.value,
          '',
        );
        expect(
          container.read(formStateProvider(typeB)).value!.fields.first.value,
          'Preenchido',
        );
      });
    });
  });
}
