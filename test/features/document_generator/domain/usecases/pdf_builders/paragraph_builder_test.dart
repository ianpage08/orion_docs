import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/paragraph_builder.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_block_type.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_build_context.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_styles.dart';

void main() {
  final builder = ParagraphBuilder();
  final styles = PdfStyles.defaults();

  PdfBuildContext ctx(String block) => PdfBuildContext(
    block: block,
    fields: [],
    styles: styles,
    blockType: PdfBlockType.paragraph,
  );

  group('ParagraphBuilder.canHandle', () {
    test('aceita paragraph', () {
      expect(builder.canHandle(PdfBlockType.paragraph), isTrue);
    });

    test('rejeita clause', () {
      expect(builder.canHandle(PdfBlockType.clause), isFalse);
    });

    test('rejeita signature', () {
      expect(builder.canHandle(PdfBlockType.signature), isFalse);
    });
  });

  group('ParagraphBuilder — espaçamento', () {
    test('sempre retorna spaceBefore 0.0', () {
      final result = builder.build(ctx('Texto simples.'));
      expect(result.spaceBefore, 0.0);
    });
  });

  group('ParagraphBuilder — renderização', () {
    test('não lança exceção para parágrafo simples', () {
      expect(() => builder.build(ctx('Parágrafo de teste.')), returnsNormally);
    });

    test('não lança exceção para parágrafo multi-linha', () {
      expect(
        () => builder.build(ctx('Linha um.\nLinha dois.\nLinha três.')),
        returnsNormally,
      );
    });
  });
}
