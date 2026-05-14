import 'package:pdf/widgets.dart' as pw;
import 'pdf_block_builder.dart';
import 'pdf_block_type.dart';
import 'pdf_build_context.dart';
import 'span_builder.dart';

class ClauseBuilder implements PdfBlockBuilder {
  static const List<String> _ordinals = [
    'primeira',
    'segunda',
    'terceira',
    'quarta',
    'quinta',
    'sexta',
    'sétima',
    'oitava',
    'nona',
    'décima',
    'décima primeira',
    'décima segunda',
    'décima terceira',
    'décima quarta',
    'décima quinta',
    'décima sexta',
    'décima sétima',
    'décima oitava',
    'décima nona',
    'vigésima',
  ];

  final SpanBuilder _spans;
  int _clauseCount = 0;
  int _subClauseCount = 0;

  ClauseBuilder({SpanBuilder spanBuilder = const SpanBuilder()})
    : _spans = spanBuilder;

  @override
  bool canHandle(PdfBlockType blockType) =>
      blockType == PdfBlockType.clause || blockType == PdfBlockType.subClause;

  @override
  ({pw.Widget widget, double spaceBefore}) build(PdfBuildContext context) {
    if (context.blockType == PdfBlockType.clause) {
      _clauseCount++;
      _subClauseCount = 0;
      return (widget: _buildClauseHeader(context), spaceBefore: 10.0);
    } else {
      _subClauseCount++;
      return (widget: _buildSubClause(context), spaceBefore: 0.0);
    }
  }

  pw.Widget _buildClauseHeader(PdfBuildContext ctx) {
    final title = ctx.block.substring('[CLAUSULA]'.length).trim();
    final prefix = 'Cláusula ${_ordinalFor(_clauseCount)}:';

    if (title.isEmpty) {
      return pw.Text(prefix, style: ctx.styles.bold, textAlign: pw.TextAlign.left);
    }

    final titleSpans = _spans.build(
      title,
      ctx.fields,
      ctx.styles.bold,
      ctx.styles.bold,
      ctx.styles.placeholder,
    );
    final allSpans = <pw.InlineSpan>[
      pw.TextSpan(text: '$prefix ', style: ctx.styles.bold),
      ...titleSpans,
    ];

    return pw.RichText(
      textAlign: pw.TextAlign.left,
      text: pw.TextSpan(children: allSpans),
    );
  }

  pw.Widget _buildSubClause(PdfBuildContext ctx) {
    final text = ctx.block.substring('[SUBCLAUSULA]'.length).trim();
    final contentSpans = _spans.build(
      text,
      ctx.fields,
      ctx.styles.normal,
      ctx.styles.bold,
      ctx.styles.placeholder,
    );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 14.0),
      child: pw.RichText(
        textAlign: pw.TextAlign.justify,
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: '$_clauseCount.$_subClauseCount ',
              style: ctx.styles.bold,
            ),
            ...contentSpans,
          ],
        ),
      ),
    );
  }

  String _ordinalFor(int n) =>
      (n >= 1 && n <= _ordinals.length) ? _ordinals[n - 1] : '$nª';
}
