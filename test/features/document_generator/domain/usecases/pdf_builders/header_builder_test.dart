import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/header_builder.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_block_type.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_build_context.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_styles.dart';

void main() {
  final builder = HeaderBuilder();
  final styles = PdfStyles.defaults();

  PdfBuildContext ctx(String block) => PdfBuildContext(
    block: block,
    fields: [],
    styles: styles,
    blockType: PdfBlockType.header,
  );

  group('HeaderBuilder.canHandle', () {
    test('aceita header', () {
      expect(builder.canHandle(PdfBlockType.header), isTrue);
    });

    test('rejeita paragraph', () {
      expect(builder.canHandle(PdfBlockType.paragraph), isFalse);
    });

    test('rejeita clause', () {
      expect(builder.canHandle(PdfBlockType.clause), isFalse);
    });
  });

  group('HeaderBuilder — espaçamento', () {
    test('sempre retorna spaceBefore 0.0', () {
      final result = builder.build(ctx('DISPOSIÇÕES FINAIS'));
      expect(result.spaceBefore, 0.0);
    });
  });

  group('HeaderBuilder — renderização', () {
    test('não lança exceção para subtítulo válido', () {
      expect(() => builder.build(ctx('DAS OBRIGAÇÕES')), returnsNormally);
    });
  });
}
