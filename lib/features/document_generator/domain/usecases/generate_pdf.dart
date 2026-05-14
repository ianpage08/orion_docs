import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../entities/document.dart';
import 'pdf_builders/clause_builder.dart';
import 'pdf_builders/header_builder.dart';
import 'pdf_builders/paragraph_builder.dart';
import 'pdf_builders/pdf_block_builder.dart';
import 'pdf_builders/pdf_build_context.dart';
import 'pdf_builders/pdf_styles.dart';
import 'pdf_builders/signature_builder.dart';
import 'pdf_builders/table_builder.dart';

class GeneratePdf {
  static const double _margin = 72.0; // 2.54 cm (Word "Normal")

  final List<PdfBlockBuilder>? _overrideBuilders;

  const GeneratePdf() : _overrideBuilders = null;

  // Construtor para testes — permite injetar builders customizados
  const GeneratePdf.withBuilders(List<PdfBlockBuilder> builders)
    : _overrideBuilders = builders;

  Future<Uint8List> call(Document document) async {
    final styles = PdfStyles.defaults();

    // ClauseBuilder instanciado por chamada → contadores zerados automaticamente
    final clauseBuilder = ClauseBuilder();
    final builders = _overrideBuilders ?? <PdfBlockBuilder>[
      SignatureBuilder(),
      clauseBuilder,       // antes de HeaderBuilder: [CLAUSULA] TÍTULO é caixa-alta
      HeaderBuilder(),
      const TableBuilder(),
      ParagraphBuilder(),  // fallback — sempre o último
    ];

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(_margin),
        footer: (_) => _buildFooter(styles),
        build: (_) => [
          _buildTitle(document.title, styles),
          pw.SizedBox(height: 20),
          ..._buildBody(document, builders, styles),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildTitle(String title, PdfStyles styles) => pw.Center(
    child: pw.Text(title, style: styles.title, textAlign: pw.TextAlign.center),
  );

  pw.Widget _buildFooter(PdfStyles styles) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 20),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('Orion Docs', style: styles.footer),
        pw.Text('https://orion-docs-seven.vercel.app/', style: styles.footer),
      ],
    ),
  );

  List<pw.Widget> _buildBody(
    Document document,
    List<PdfBlockBuilder> builders,
    PdfStyles styles,
  ) {
    final blocks = document.templateText.split('\n\n');
    final widgets = <pw.Widget>[];

    for (final block in blocks) {
      final trimmed = block.trim();
      if (trimmed.isEmpty) continue;

      final context = PdfBuildContext.fromBlock(
        block: trimmed,
        fields: document.fields,
        styles: styles,
      );

      final builder = builders.firstWhere((b) => b.canHandle(context.blockType));
      final (:widget, :spaceBefore) = builder.build(context);

      if (spaceBefore > 0 && widgets.isNotEmpty) {
        widgets.add(pw.SizedBox(height: spaceBefore));
      }
      widgets.add(widget);
      widgets.add(pw.SizedBox(height: 6));
    }

    return widgets;
  }
}
