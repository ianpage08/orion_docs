import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class DocumentTemplate {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;

  const DocumentTemplate({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
  });
}

@immutable
class RecentFile {
  final String name;
  final String path;
  final DateTime generatedAt;

  const RecentFile({
    required this.name,
    required this.path,
    required this.generatedAt,
  });
}

const _mockTemplates = <DocumentTemplate>[
  DocumentTemplate(
    id: 'contrato_aluguel',
    name: 'Contrato de Aluguel',
    subtitle: 'Residencial ou comercial',
    icon: Icons.home_outlined,
  ),
  DocumentTemplate(
    id: 'recibo_simples',
    name: 'Recibo Simples',
    subtitle: 'Comprovante de pagamento',
    icon: Icons.receipt_long_outlined,
  ),
  DocumentTemplate(
    id: 'alteracao_titularidade',
    name: 'Procuração',
    subtitle: 'Alteração de titularidade',
    icon: Icons.gavel,
  ),
  DocumentTemplate(
    id: 'residencia',
    name: 'Declaração de Residência',
    subtitle: 'Comprovante de domicílio',
    icon: Icons.location_city_outlined,
  ),
  DocumentTemplate(
    id: 'contrato_compra_venda',
    name: 'Compra e Venda',
    subtitle: 'Transferência de bem',
    icon: Icons.handshake_outlined,
  ),
  DocumentTemplate(
    id: 'ligacao_nova',
    name: 'Ligação Nova',
    subtitle: 'Serviço de água/esgoto',
    icon: Icons.electrical_services,
  ),
];

final _mockRecents = <RecentFile>[
  RecentFile(
    name: 'Contrato de Aluguel - João Silva',
    path: r'C:\OrionDocs\Output\contrato_aluguel_joao.pdf',
    generatedAt: DateTime(2026, 5, 5, 14, 32),
  ),
  RecentFile(
    name: 'Recibo Simples - Maria Souza',
    path: r'C:\OrionDocs\Output\recibo_maria.pdf',
    generatedAt: DateTime(2026, 5, 3, 9, 11),
  ),
  RecentFile(
    name: 'Procuração - Pedro Alves',
    path: r'C:\OrionDocs\Output\procuracao_pedro.pdf',
    generatedAt: DateTime(2026, 5, 1, 17, 45),
  ),
  RecentFile(
    name: 'Declaração de Residência - Ana Lima',
    path: r'C:\OrionDocs\Output\declaracao_residencia_ana.pdf',
    generatedAt: DateTime(2026, 4, 28, 10, 20),
  ),
  RecentFile(
    name: 'Contrato de Compra e Venda - Rui Neto',
    path: r'C:\OrionDocs\Output\compra_venda_rui.pdf',
    generatedAt: DateTime(2026, 4, 25, 8, 55),
  ),
];

final documentTemplatesProvider = Provider<List<DocumentTemplate>>(
  (_) => _mockTemplates,
);

final recentFilesProvider = Provider<List<RecentFile>>(
  (_) => _mockRecents,
);
