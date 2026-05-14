import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_block_type.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_build_context.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_styles.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/signature_builder.dart';

void main() {
  final builder = SignatureBuilder();
  final styles = PdfStyles.defaults();

  PdfBuildContext ctx(String block) => PdfBuildContext(
    block: block,
    fields: [],
    styles: styles,
    blockType: PdfBlockType.signature,
  );

  group('SignatureBuilder.canHandle', () {
    test('aceita signature', () {
      expect(builder.canHandle(PdfBlockType.signature), isTrue);
    });

    test('rejeita paragraph', () {
      expect(builder.canHandle(PdfBlockType.paragraph), isFalse);
    });

    test('rejeita clause', () {
      expect(builder.canHandle(PdfBlockType.clause), isFalse);
    });
  });

  group('SignatureBuilder — espaçamento', () {
    test('sempre retorna spaceBefore 20.0', () {
      final result = builder.build(ctx('_____\nJoão Silva\nCPF: 000.000.000-00'));
      expect(result.spaceBefore, 20.0);
    });
  });

  group('SignatureBuilder — renderização', () {
    test('não lança exceção para bloco de assinatura completo', () {
      expect(
        () => builder.build(
          ctx('CONTRATANTE\n_____\nJoão Silva\nCPF: 000.000.000-00'),
        ),
        returnsNormally,
      );
    });
  });
}
