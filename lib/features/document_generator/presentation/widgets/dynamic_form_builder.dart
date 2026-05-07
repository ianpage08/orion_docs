import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/document.dart';
import '../../domain/entities/document_type.dart';
import '../../domain/entities/field.dart';
import '../providers/document_providers.dart';
import 'clear_button.dart';
import 'form_field_widget.dart';
import 'generate_button.dart';
import 'preview_panel.dart';

String _docId(DocumentType type) => switch (type) {
      DocumentType.contratoAluguel => 'CTR-AL-001',
      DocumentType.contratoCompraVenda => 'CTR-CV-001',
      DocumentType.contratoDoacao => 'CTR-DO-001',
      DocumentType.reciboSimples => 'RCB-SM-001',
      DocumentType.reciboAluguel => 'RCB-AL-001',
      DocumentType.conformidadeSonora => 'AUT-PS-001',
      DocumentType.baixoImpacto => 'AUT-BI-001',
      DocumentType.ligacaoNova => 'REQ-LN-001',
      DocumentType.alteracaoTitularidade => 'PRO-AT-001',
      DocumentType.residencia => 'DCL-RS-001',
    };

class DynamicFormBuilder extends ConsumerWidget {
  const DynamicFormBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(formStateProvider);

    if (document == null) {
      return const ColoredBox(
        color: Color(0xFF0B0F1A),
        child: Center(child: CircularProgressIndicator(color: Color(0xFF00BCD4))),
      );
    }

    final filled = document.fields.where((f) => f.value.isNotEmpty).length;
    final total = document.fields.length;
    final progress = total > 0 ? filled / total : 0.0;
    final docId = _docId(document.type);

    return ColoredBox(
      color: const Color(0xFF0B0F1A),
      child: Column(
        children: [
          _buildBreadcrumb(docId, filled, total),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormHeader(),
                Expanded(child: _buildFormCard(document, filled, total, progress)),
                _buildFooter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(String docId, int filled, int total) {
    return Container(
      height: 44,
      color: const Color(0xFF060912),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF00FF87),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'GERADOR  •  $docId',
            style: const TextStyle(
              color: Color(0xFF00BCD4),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          const Text(
            'PROGRESSO  ',
            style: TextStyle(color: Color(0xFF555570), fontSize: 11, letterSpacing: 0.8),
          ),
          Text(
            '$filled/$total',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 14),
          const Text('|', style: TextStyle(color: Color(0xFF2A2A4A), fontSize: 16)),
          const SizedBox(width: 14),
          const Text(
            'MODELO  ',
            style: TextStyle(color: Color(0xFF555570), fontSize: 11, letterSpacing: 0.8),
          ),
          const Text(
            'ATIVO',
            style: TextStyle(
              color: Color(0xFF00BCD4),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF00BCD4),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gerador de Arquivos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Selecione um modelo e preencha as variáveis abaixo.\nO preview à direita atualiza em tempo real.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(Document document, int filled, int total, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF10101E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A3F)),
        ),
        child: Column(
          children: [
            _buildCardHeader(filled, total, progress),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final singleCol = constraints.maxWidth < 500;
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    children: _buildFieldPairs(document.fields, singleCol: singleCol),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(int filled, int total, double progress) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A3F))),
      ),
      child: Row(
        children: [
          const Text(
            '[ DADOS DO CONTRATO ]',
            style: TextStyle(
              color: Color(0xFF00BCD4),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 72,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF2A2A3F),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF00BCD4)),
              minHeight: 3,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(
              color: Color(0xFF00BCD4),
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFieldPairs(List<Field> fields, {bool singleCol = false}) {
    final rows = <Widget>[];

    if (singleCol) {
      for (int i = 0; i < fields.length; i++) {
        rows.add(FormFieldWidget(key: ValueKey(fields[i].id), field: fields[i], index: i + 1));
        if (i < fields.length - 1) rows.add(const SizedBox(height: 12));
      }
      return rows;
    }

    for (int i = 0; i < fields.length; i += 2) {
      final field1 = fields[i];
      final field2 = i + 1 < fields.length ? fields[i + 1] : null;
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FormFieldWidget(
                key: ValueKey(field1.id),
                field: field1,
                index: i + 1,
              ),
            ),
            const SizedBox(width: 12),
            if (field2 != null)
              Expanded(
                child: FormFieldWidget(
                  key: ValueKey(field2.id),
                  field: field2,
                  index: i + 2,
                ),
              )
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      );
      if (i + 2 < fields.length) rows.add(const SizedBox(height: 12));
    }
    return rows;
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF060912),
        border: Border(top: BorderSide(color: Color(0xFF1A1A2A))),
      ),
      child: Row(
        children: [
          const ClearButton(),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => Dialog.fullscreen(
                child: Scaffold(
                  backgroundColor: const Color(0xFF0D0D1A),
                  appBar: AppBar(
                    backgroundColor: const Color(0xFF060912),
                    iconTheme: const IconThemeData(color: Colors.white),
                    title: const Text(
                      'Visualização',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    elevation: 0,
                  ),
                  body: const PreviewPanel(),
                ),
              ),
            ),
            icon: const Icon(Icons.open_in_full, size: 15),
            label: const Text('Tela cheia', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF2A2A3F)),
              foregroundColor: const Color(0xFFAAAAAA),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(child: GenerateButton()),
        ],
      ),
    );
  }
}
