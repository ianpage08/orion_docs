import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/document_model.dart';
import '../../domain/entities/document_type.dart';

class LocalTemplateDatasource {
  const LocalTemplateDatasource();

  Future<DocumentModel> loadTemplate(DocumentType type) async {
    final path = _assetPath(type);
    final jsonString = await rootBundle.loadString(path);
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return DocumentModel.fromJson(json);
  }

  static String _assetPath(DocumentType type) => switch (type) {
        DocumentType.contratoAluguel =>
          'assets/templates/contrato_aluguel.json',
        DocumentType.contratoCompraVenda =>
          'assets/templates/contrato_compra_venda.json',
        DocumentType.contratoDoacao =>
          'assets/templates/contrato_doacao.json',
        DocumentType.reciboSimples => 'assets/templates/recibo_simples.json',
        DocumentType.reciboAluguel => 'assets/templates/recibo_aluguel.json',
        DocumentType.conformidadeSonora =>
          'assets/templates/conformidade_sonora.json',
        DocumentType.baixoImpacto => 'assets/templates/baixo_impacto.json',
        DocumentType.ligacaoNova => 'assets/templates/ligacao_nova.json',
        DocumentType.alteracaoTitularidade =>
          'assets/templates/alteracao_titularidade.json',
        DocumentType.residencia => 'assets/templates/residencia.json',
      };
}
