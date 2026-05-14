import 'package:pdf/widgets.dart' as pw;
import 'pdf_block_builder.dart';
import 'pdf_block_type.dart';
import 'pdf_build_context.dart';
import 'span_builder.dart';

class HeaderBuilder implements PdfBlockBuilder {
  final SpanBuilder _spans;

  HeaderBuilder({SpanBuilder spanBuilder = const SpanBuilder()})
    : _spans = spanBuilder;

  @override
  bool canHandle(PdfBlockType blockType) => blockType == PdfBlockType.header;

  @override
  ({pw.Widget widget, double spaceBefore}) build(PdfBuildContext context) =>
      (widget: _buildSubtitle(context), spaceBefore: 0.0);

  pw.Widget _buildSubtitle(PdfBuildContext ctx) {
    final spans = _spans.build(
      ctx.block,
      ctx.fields,
      ctx.styles.bold,
      ctx.styles.bold,
      ctx.styles.placeholder,
    );
    return pw.RichText(
      textAlign: pw.TextAlign.left,
      text: pw.TextSpan(children: spans),
    );
  }
}
