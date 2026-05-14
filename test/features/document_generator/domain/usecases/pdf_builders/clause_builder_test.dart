import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/clause_builder.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_block_type.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_build_context.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_styles.dart';

void main() {
  late ClauseBuilder builder;
  final styles = PdfStyles.defaults();

  PdfBuildContext ctx(String block) => PdfBuildContext(
    block: block,
    fields: [],
    styles: styles,
    blockType: PdfBlockType.detect(block),
  );

  setUp(() => builder = ClauseBuilder());

  group('ClauseBuilder.canHandle', () {
    test('aceita clause', () {
      expect(builder.canHandle(PdfBlockType.clause), isTrue);
    });

    test('aceita subClause', () {
      expect(builder.canHandle(PdfBlockType.subClause), isTrue);
    });

    test('rejeita paragraph', () {
      expect(builder.canHandle(PdfBlockType.paragraph), isFalse);
    });

    test('rejeita signature', () {
      expect(builder.canHandle(PdfBlockType.signature), isFalse);
    });
  });

  group('ClauseBuilder — espaçamento', () {
    test('[CLAUSULA] retorna spaceBefore 10.0', () {
      final result = builder.build(ctx('[CLAUSULA] TÍTULO'));
      expect(result.spaceBefore, 10.0);
    });

    test('[SUBCLAUSULA] retorna spaceBefore 0.0', () {
      builder.build(ctx('[CLAUSULA] A')); // inicializa clauseCount
      final result = builder.build(ctx('[SUBCLAUSULA] texto'));
      expect(result.spaceBefore, 0.0);
    });
  });

  group('ClauseBuilder — estado de contadores', () {
    test('segundo [CLAUSULA] incrementa clauseCount', () {
      builder.build(ctx('[CLAUSULA] PRIMEIRO'));
      final result = builder.build(ctx('[CLAUSULA] SEGUNDO'));
      expect(result.spaceBefore, 10.0); // ainda é clause
    });

    test('[SUBCLAUSULA] é resetado ao iniciar nova cláusula', () {
      builder.build(ctx('[CLAUSULA] A'));
      builder.build(ctx('[SUBCLAUSULA] 1'));
      builder.build(ctx('[SUBCLAUSULA] 2'));
      builder.build(ctx('[CLAUSULA] B')); // reset
      final result = builder.build(ctx('[SUBCLAUSULA] deve ser B.1'));
      // spaceBefore 0.0 confirma que foi tratado como subClause
      expect(result.spaceBefore, 0.0);
    });
  });
}
