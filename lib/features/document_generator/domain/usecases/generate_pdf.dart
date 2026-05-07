import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../entities/document.dart';
import '../entities/field.dart';

class GeneratePdf {
  const GeneratePdf();

  static const double _margin = 72.0; // 2.54 cm (Word "Normal")
  static const double _fontSize = 12.0;
  static const String _firstLineIndent = '    '; // ≈ 0.5 cm em Helvetica 12pt

  Future<Uint8List> call(Document document) async {
    final pdf = pw.Document();

    final normalFont = pw.Font.helvetica();
    final boldFont = pw.Font.helveticaBold();

    final normalStyle = pw.TextStyle(font: normalFont, fontSize: _fontSize);
    final boldStyle = pw.TextStyle(
      font: boldFont,
      fontSize: _fontSize,
      fontWeight: pw.FontWeight.bold,
    );
    final placeholderStyle = pw.TextStyle(
      font: normalFont,
      fontSize: _fontSize,
      color: PdfColors.grey,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(_margin),
        build: (_) => [
          // Título — centralizado, negrito
          pw.Center(
            child: pw.Text(
              document.title,
              style: boldStyle,
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.SizedBox(height: 20),
          ..._buildBody(document, normalStyle, boldStyle, placeholderStyle),
        ],
      ),
    );

    return pdf.save();
  }

  List<pw.Widget> _buildBody(
    Document document,
    pw.TextStyle normalStyle,
    pw.TextStyle boldStyle,
    pw.TextStyle placeholderStyle,
  ) {
    final blocks = document.templateText.split('\n\n');
    final widgets = <pw.Widget>[];
    int clauseCount = 0;
    int subClauseCount = 0;

    for (final block in blocks) {
      final trimmed = block.trim();
      if (trimmed.isEmpty) continue;

      pw.Widget widget;
      bool extraSpaceBefore = false;

      if (_isSignatureBlock(trimmed)) {
        widget = _buildSignatureBlock(
            trimmed, document.fields, normalStyle, boldStyle, placeholderStyle);
      } else if (trimmed.startsWith('[CLAUSULA]')) {
        clauseCount++;
        subClauseCount = 0;
        extraSpaceBefore = true;
        widget = _buildClauseHeader(
            trimmed, clauseCount, document.fields, boldStyle, placeholderStyle);
      } else if (trimmed.startsWith('[SUBCLAUSULA]')) {
        subClauseCount++;
        widget = _buildSubClause(trimmed, clauseCount, subClauseCount,
            document.fields, normalStyle, boldStyle, placeholderStyle);
      } else if (_isSubtitle(trimmed)) {
        // Subtítulo — alinhado à esquerda total
        widget = _buildSubtitle(
            trimmed, document.fields, boldStyle, placeholderStyle);
      } else {
        widget = _buildParagraph(
            trimmed, document.fields, normalStyle, boldStyle, placeholderStyle);
      }

      if (extraSpaceBefore && widgets.isNotEmpty) {
        widgets.add(pw.SizedBox(height: 10));
      }
      widgets.add(widget);
      widgets.add(pw.SizedBox(height: 6));
    }

    return widgets;
  }

  // Bloco com linha de assinatura (underscores consecutivos)
  bool _isSignatureBlock(String block) {
    return block.split('\n').any(
      (line) => RegExp(r'^_+$').hasMatch(line.trim()) && line.trim().length >= 5,
    );
  }

  // Subtítulo: linha única, caixa alta, sem campos, menos de 60 chars
  bool _isSubtitle(String block) {
    final lines = block.split('\n');
    if (lines.length != 1) return false;
    final line = lines[0].trim();
    return line.isNotEmpty &&
        line.length < 60 &&
        !line.contains('{{') &&
        line.toUpperCase() == line;
  }

  // "Cláusula N – TÍTULO" — esquerda total, negrito
  pw.Widget _buildClauseHeader(
    String block,
    int number,
    List<Field> fields,
    pw.TextStyle boldStyle,
    pw.TextStyle placeholderStyle,
  ) {
    final title = block.substring('[CLAUSULA]'.length).trim();
    final prefix = 'Cláusula $number';

    if (title.isEmpty) {
      return pw.Text(prefix, style: boldStyle, textAlign: pw.TextAlign.left);
    }

    final titleSpans =
        _buildSpans(title, fields, boldStyle, boldStyle, placeholderStyle);
    final allSpans = <pw.InlineSpan>[
      pw.TextSpan(text: '$prefix – ', style: boldStyle),
      ...titleSpans,
    ];

    return pw.RichText(
      textAlign: pw.TextAlign.left,
      text: pw.TextSpan(children: allSpans),
    );
  }

  // "N.M Texto" — esquerda com recuo leve, justificado
  pw.Widget _buildSubClause(
    String block,
    int clause,
    int sub,
    List<Field> fields,
    pw.TextStyle normalStyle,
    pw.TextStyle boldStyle,
    pw.TextStyle placeholderStyle,
  ) {
    final text = block.substring('[SUBCLAUSULA]'.length).trim();
    final contentSpans =
        _buildSpans(text, fields, normalStyle, boldStyle, placeholderStyle);

    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 14.0),
      child: pw.RichText(
        textAlign: pw.TextAlign.justify,
        text: pw.TextSpan(children: [
          pw.TextSpan(text: '$clause.$sub ', style: boldStyle),
          ...contentSpans,
        ]),
      ),
    );
  }

  // Subtítulo — alinhado à esquerda total, negrito, sem recuo
  pw.Widget _buildSubtitle(
    String block,
    List<Field> fields,
    pw.TextStyle boldStyle,
    pw.TextStyle placeholderStyle,
  ) {
    final spans =
        _buildSpans(block, fields, boldStyle, boldStyle, placeholderStyle);
    return pw.RichText(
      textAlign: pw.TextAlign.left,
      text: pw.TextSpan(children: spans),
    );
  }

  // Assinatura — centralizada
  // Primeira linha após ___ = nome (negrito); demais = CPF/cargo (normal)
  pw.Widget _buildSignatureBlock(
    String block,
    List<Field> fields,
    pw.TextStyle normalStyle,
    pw.TextStyle boldStyle,
    pw.TextStyle placeholderStyle,
  ) {
    final lines = block.split('\n');
    final children = <pw.Widget>[];
    bool prevWasUnderline = false;
    bool isFirstAfterUnderline = false;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        children.add(pw.SizedBox(height: 8));
        prevWasUnderline = false;
        isFirstAfterUnderline = false;
        continue;
      }

      final isUnderline = RegExp(r'^_+$').hasMatch(trimmed);

      if (isUnderline) {
        children.add(pw.Center(child: pw.Text(trimmed, style: normalStyle)));
        prevWasUnderline = true;
        isFirstAfterUnderline = true;
      } else if (prevWasUnderline && isFirstAfterUnderline) {
        // Nome — negrito, centralizado
        isFirstAfterUnderline = false;
        final spans =
            _buildSpans(trimmed, fields, boldStyle, boldStyle, placeholderStyle);
        children.add(pw.Center(
          child: pw.RichText(
            textAlign: pw.TextAlign.center,
            text: pw.TextSpan(children: spans),
          ),
        ));
      } else if (prevWasUnderline) {
        // CPF, cargo ou testemunha — normal, centralizado
        final spans = _buildSpans(
            trimmed, fields, normalStyle, boldStyle, placeholderStyle);
        children.add(pw.Center(
          child: pw.RichText(
            textAlign: pw.TextAlign.center,
            text: pw.TextSpan(children: spans),
          ),
        ));
      } else {
        // Rótulo de seção (ex.: "DOADORES", "TESTEMUNHAS:") — negrito, centralizado
        final spans =
            _buildSpans(trimmed, fields, boldStyle, boldStyle, placeholderStyle);
        children.add(pw.Center(
          child: pw.RichText(
            textAlign: pw.TextAlign.center,
            text: pw.TextSpan(children: spans),
          ),
        ));
        prevWasUnderline = false;
        isFirstAfterUnderline = false;
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: children,
    );
  }

  // Parágrafo — justificado, recuo de 0,5 cm na primeira linha
  pw.Widget _buildParagraph(
    String block,
    List<Field> fields,
    pw.TextStyle normalStyle,
    pw.TextStyle boldStyle,
    pw.TextStyle placeholderStyle,
  ) {
    final lines = block.split('\n');
    final allSpans = <pw.InlineSpan>[];

    for (int i = 0; i < lines.length; i++) {
      if (i > 0) {
        allSpans.add(pw.TextSpan(text: '\n', style: normalStyle));
      }
      final prefix = i == 0 ? _firstLineIndent : '';
      final spans = _buildSpans(
          prefix + lines[i], fields, normalStyle, boldStyle, placeholderStyle);
      allSpans.addAll(spans);
    }

    return pw.RichText(
      textAlign: pw.TextAlign.justify,
      text: pw.TextSpan(children: allSpans),
    );
  }

  // Constrói spans: campos preenchidos em negrito, placeholders em cinza
  List<pw.InlineSpan> _buildSpans(
    String templateText,
    List<Field> fields,
    pw.TextStyle normalStyle,
    pw.TextStyle boldStyle,
    pw.TextStyle placeholderStyle,
  ) {
    final spans = <pw.InlineSpan>[];
    final regex = RegExp(r'\{\{(\w+)\}\}');
    int lastEnd = 0;

    for (final match in regex.allMatches(templateText)) {
      if (match.start > lastEnd) {
        spans.add(pw.TextSpan(
          text: templateText.substring(lastEnd, match.start),
          style: normalStyle,
        ));
      }

      final fieldId = match.group(1)!;
      final field = fields.firstWhere(
        (f) => f.id == fieldId,
        orElse: () => Field(
          id: fieldId,
          label: fieldId,
          type: FieldType.text,
          required: false,
        ),
      );

      if (field.value.isEmpty) {
        spans.add(pw.TextSpan(
            text: '[${field.label}]', style: placeholderStyle));
      } else {
        spans.add(pw.TextSpan(text: field.value, style: boldStyle));
      }

      lastEnd = match.end;
    }

    if (lastEnd < templateText.length) {
      spans.add(pw.TextSpan(
        text: templateText.substring(lastEnd),
        style: normalStyle,
      ));
    }

    return spans;
  }
}
