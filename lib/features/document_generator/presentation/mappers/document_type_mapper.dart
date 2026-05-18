import '../../domain/entities/document_type.dart';

abstract final class DocumentTypeMapper {
  static DocumentType? fromSidebarId(String? id) => switch (id) {
        'contrato_aluguel' => DocumentType.contratoAluguel,
        'contrato_compra_venda' => DocumentType.contratoCompraVenda,
        'contrato_doacao' => DocumentType.contratoDoacao,
        'recibo_simples' => DocumentType.reciboSimples,
        'recibo_aluguel' => DocumentType.reciboAluguel,
        'conformidade_sonora' => DocumentType.conformidadeSonora,
        'baixo_impacto' => DocumentType.baixoImpacto,
        'ligacao_nova' => DocumentType.ligacaoNova,
        'alteracao_titularidade' => DocumentType.alteracaoTitularidade,
        'residencia' => DocumentType.residencia,
        _ => null,
      };
}
