import 'package:pdf/widgets.dart' as pw;
import 'pdf_block_builder.dart';
import 'pdf_block_type.dart';
import 'pdf_build_context.dart';
import 'span_builder.dart';

class ParagraphBuilder implements PdfBlockBuilder {
  static const String _firstLineIndent = '    ';

  final SpanBuilder _spans;

  ParagraphBuilder({SpanBuilder spanBuilder = const SpanBuilder()})
    : _spans = spanBuilder;

  @override
  bool canHandle(PdfBlockType blockType) => blockType == PdfBlockType.paragraph;

  @override
  ({pw.Widget widget, double spaceBefore}) build(PdfBuildContext context) =>
      (widget: _buildParagraph(context), spaceBefore: 0.0);

  pw.Widget _buildParagraph(PdfBuildContext ctx) {
    final lines = ctx.block.split('\n');
    final allSpans = <pw.InlineSpan>[];

    for (int i = 0; i < lines.length; i++) {
      if (i > 0) {
        allSpans.add(pw.TextSpan(text: '\n', style: ctx.styles.normal));
      }
      final prefix = i == 0 ? _firstLineIndent : '';
      allSpans.addAll(
        _spans.build(
          prefix + lines[i],
          ctx.fields,
          ctx.styles.normal,
          ctx.styles.bold,
          ctx.styles.placeholder,
        ),
      );
    }

    return pw.RichText(
      textAlign: pw.TextAlign.justify,
      text: pw.TextSpan(children: allSpans),
    );
  }
}
