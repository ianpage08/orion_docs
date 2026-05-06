import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/document.dart';
import '../../domain/entities/document_type.dart';
import '../providers/document_providers.dart';

String _docIdForPreview(DocumentType type) => switch (type) {
      DocumentType.contratoAluguel => 'CTR-AL-001',
      DocumentType.contratoCompraVenda => 'CTR-CV-001',
      DocumentType.contratoDoacao => 'CTR-DO-001',
      DocumentType.reciboSimples => 'RCB-SM-001',
      DocumentType.reciboAluguel => 'RCB-AL-001',
      DocumentType.conformidadeSonora => 'AUT-PS-001',
      DocumentType.baixoImpacto => 'AUT-BI-001',
      DocumentType.ligacaoNova => 'REQ-LN-001',
      DocumentType.alteracaoTitularidade => 'PRO-AT-001',
    };

class PreviewPanel extends ConsumerStatefulWidget {
  const PreviewPanel({super.key});

  @override
  ConsumerState<PreviewPanel> createState() => _PreviewPanelState();
}

class _PreviewPanelState extends ConsumerState<PreviewPanel> {
  int _tabIndex = 0;
  int _zoomPct = 100;

  @override
  Widget build(BuildContext context) {
    final document = ref.watch(formStateProvider);

    return ColoredBox(
      color: const Color(0xFF0D0D1A),
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildBody(document)),
          if (document != null) _buildInfoBar(document),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 44,
      color: const Color(0xFF060912),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _TabBtn(
            icon: Icons.remove_red_eye_outlined,
            label: 'PREVIEW',
            active: _tabIndex == 0,
            onTap: () => setState(() => _tabIndex = 0),
          ),
          const SizedBox(width: 2),
          _TabBtn(
            icon: Icons.code_rounded,
            label: 'CÓDIGO',
            active: _tabIndex == 1,
            onTap: () => setState(() => _tabIndex = 1),
          ),
          const Spacer(),
          _ZoomBtn(icon: Icons.remove, onTap: () {
            if (_zoomPct > 50) setState(() => _zoomPct -= 10);
          }),
          const SizedBox(width: 6),
          Text(
            '$_zoomPct%',
            style: const TextStyle(
              color: Color(0xFF8888A0),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          _ZoomBtn(icon: Icons.add, onTap: () {
            if (_zoomPct < 200) setState(() => _zoomPct += 10);
          }),
          const SizedBox(width: 14),
          _ZoomBtn(icon: Icons.print_outlined, onTap: () {}),
          const SizedBox(width: 4),
          _ZoomBtn(icon: Icons.send_outlined, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildBody(Document? document) {
    if (document == null) {
      return const Center(
        child: Text(
          'Selecione um documento para visualizar o preview',
          style: TextStyle(color: Color(0xFF3A3A5A), fontSize: 13),
        ),
      );
    }

    if (_tabIndex == 1) {
      return _buildCodeView(document);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(child: _buildPaper(document)),
    );
  }

  Widget _buildCodeView(Document document) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Text(
        document.templateText,
        style: const TextStyle(
          color: Color(0xFF8888B0),
          fontSize: 11,
          fontFamily: 'monospace',
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildPaper(Document document) {
    final docId = _docIdForPreview(document.type);
    return Container(
      width: 595,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                docId,
                style: const TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 9.5,
                  letterSpacing: 1.2,
                  fontFamily: 'monospace',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00BCD4), width: 1),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  'RASCUNHO',
                  style: TextStyle(
                    color: Color(0xFF00BCD4),
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFE0E0E0), thickness: 0.5),
          const SizedBox(height: 18),
          Center(
            child: Text(
              document.title.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(children: _buildRichSpans(document)),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _buildRichSpans(Document document) {
    final fieldMap = {
      for (final f in document.fields) '{{${f.id}}}': f,
    };

    final pattern = RegExp(r'\{\{[^}]+\}\}');

    const staticStyle = TextStyle(
      color: Color(0xFF1A1A1A),
      fontSize: 11,
      height: 1.75,
    );

    const filledStyle = TextStyle(
      color: Color(0xFF00BCD4),
      fontSize: 11,
      height: 1.75,
      fontWeight: FontWeight.w600,
    );

    const emptyStyle = TextStyle(
      color: Color(0xFFBBBBCC),
      fontSize: 11,
      height: 1.75,
      fontStyle: FontStyle.italic,
    );

    final spans = <InlineSpan>[];
    int lastEnd = 0;

    for (final match in pattern.allMatches(document.templateText)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: document.templateText.substring(lastEnd, match.start),
          style: staticStyle,
        ));
      }

      final placeholder = match.group(0)!;
      final field = fieldMap[placeholder];

      if (field != null) {
        final display = field.value.isEmpty ? '[${field.label}]' : field.value;
        spans.add(TextSpan(
          text: display,
          style: field.value.isEmpty ? emptyStyle : filledStyle,
        ));
      } else {
        spans.add(TextSpan(text: placeholder, style: staticStyle));
      }

      lastEnd = match.end;
    }

    if (lastEnd < document.templateText.length) {
      spans.add(TextSpan(
        text: document.templateText.substring(lastEnd),
        style: staticStyle,
      ));
    }

    return spans;
  }

  Widget _buildInfoBar(Document document) {
    final fieldCount = document.fields.length;
    return Container(
      height: 36,
      color: const Color(0xFF060912),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _InfoLabel('FORMATO', 'A4 − 210×297 mm'),
          _infoDiv(),
          _InfoLabel('PÁGINAS', '1'),
          _infoDiv(),
          _InfoLabel('CAMPOS DINÂMICOS', '$fieldCount VARIÁVEIS'),
        ],
      ),
    );
  }

  Widget _infoDiv() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Text('|', style: TextStyle(color: Color(0xFF2A2A4A), fontSize: 14)),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabBtn({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? const Color(0xFF00BCD4) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (active)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFF00BCD4),
                  shape: BoxShape.circle,
                ),
              ),
            Icon(
              icon,
              size: 14,
              color: active ? const Color(0xFF00BCD4) : const Color(0xFF555570),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? const Color(0xFF00BCD4) : const Color(0xFF555570),
                fontSize: 11,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 15, color: const Color(0xFF555570)),
      ),
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLabel(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label  ',
          style: const TextStyle(color: Color(0xFF444460), fontSize: 10, letterSpacing: 0.6),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF8888A0),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
