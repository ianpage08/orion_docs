import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/document_generator/domain/entities/document_type.dart';
import 'package:orion_docs/features/document_generator/presentation/mappers/document_type_mapper.dart';

void main() {
  group('DocumentTypeMapper.fromSidebarId', () {
    test('mapeia todos os IDs conhecidos corretamente', () {
      final cases = {
        'contrato_aluguel': DocumentType.contratoAluguel,
        'contrato_compra_venda': DocumentType.contratoCompraVenda,
        'contrato_doacao': DocumentType.contratoDoacao,
        'recibo_simples': DocumentType.reciboSimples,
        'recibo_aluguel': DocumentType.reciboAluguel,
        'conformidade_sonora': DocumentType.conformidadeSonora,
        'baixo_impacto': DocumentType.baixoImpacto,
        'ligacao_nova': DocumentType.ligacaoNova,
        'alteracao_titularidade': DocumentType.alteracaoTitularidade,
        'residencia': DocumentType.residencia,
      };

      for (final entry in cases.entries) {
        expect(
          DocumentTypeMapper.fromSidebarId(entry.key),
          entry.value,
          reason: "'${entry.key}' deveria mapear para ${entry.value}",
        );
      }
    });

    test('retorna null para entrada nula', () {
      expect(DocumentTypeMapper.fromSidebarId(null), isNull);
    });

    test('retorna null para string vazia', () {
      expect(DocumentTypeMapper.fromSidebarId(''), isNull);
    });

    test('retorna null para IDs desconhecidos', () {
      expect(DocumentTypeMapper.fromSidebarId('unknown_id'), isNull);
      expect(DocumentTypeMapper.fromSidebarId('feedback'), isNull);
      expect(DocumentTypeMapper.fromSidebarId('home'), isNull);
    });

    test('é case-sensitive — maiúsculas não fazem match', () {
      expect(DocumentTypeMapper.fromSidebarId('CONTRATO_ALUGUEL'), isNull);
      expect(DocumentTypeMapper.fromSidebarId('Recibo_Simples'), isNull);
    });
  });
}
