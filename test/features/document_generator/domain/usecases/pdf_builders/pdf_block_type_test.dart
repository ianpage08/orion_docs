import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/pdf_block_type.dart';

void main() {
  group('PdfBlockType.detect — marcadores explícitos', () {
    test('[CLAUSULA] detecta clause', () {
      expect(PdfBlockType.detect('[CLAUSULA] TÍTULO'), PdfBlockType.clause);
    });

    test('[SUBCLAUSULA] detecta subClause', () {
      expect(PdfBlockType.detect('[SUBCLAUSULA] texto'), PdfBlockType.subClause);
    });

    test('[TABELA] detecta table', () {
      expect(PdfBlockType.detect('[TABELA] dados'), PdfBlockType.table);
    });
  });

  group('PdfBlockType.detect — assinatura', () {
    test('linha com 5+ underscores detecta signature', () {
      expect(PdfBlockType.detect('_____\nJoão Silva'), PdfBlockType.signature);
    });

    test('menos de 5 underscores não é assinatura', () {
      expect(PdfBlockType.detect('____'), isNot(PdfBlockType.signature));
    });
  });

  group('PdfBlockType.detect — header (subtítulo)', () {
    test('linha caixa-alta < 60 chars sem {{ é header', () {
      expect(PdfBlockType.detect('DISPOSIÇÕES FINAIS'), PdfBlockType.header);
    });

    test('linha com {{ não é header', () {
      expect(PdfBlockType.detect('OLÁ {{nome}}'), isNot(PdfBlockType.header));
    });

    test('linha com mais de 59 chars não é header', () {
      expect(PdfBlockType.detect('A' * 60), isNot(PdfBlockType.header));
    });

    test('linha mista (não caixa-alta) não é header', () {
      expect(PdfBlockType.detect('Texto Normal'), isNot(PdfBlockType.header));
    });

    test('múltiplas linhas não é header', () {
      expect(PdfBlockType.detect('LINHA UM\nLINHA DOIS'), isNot(PdfBlockType.header));
    });
  });

  group('PdfBlockType.detect — parágrafo (fallback)', () {
    test('texto normal vira paragraph', () {
      expect(PdfBlockType.detect('Este é um parágrafo.'), PdfBlockType.paragraph);
    });

    test('texto misto com campos vira paragraph', () {
      expect(PdfBlockType.detect('O contratante {{nome}} se compromete...'), PdfBlockType.paragraph);
    });
  });
}
