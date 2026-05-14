import 'package:pdf/widgets.dart' as pw;
import 'pdf_block_builder.dart';
import 'pdf_block_type.dart';
import 'pdf_build_context.dart';
import 'span_builder.dart';

class SignatureBuilder implements PdfBlockBuilder {
  final SpanBuilder _spans;

  SignatureBuilder({SpanBuilder spanBuilder = const SpanBuilder()})
    : _spans = spanBuilder;

  @override
  bool canHandle(PdfBlockType blockType) => blockType == PdfBlockType.signature;

  @override
  ({pw.Widget widget, double spaceBefore}) build(PdfBuildContext context) =>
      (widget: _buildSignatureBlock(context), spaceBefore: 20.0);

  pw.Widget _buildSignatureBlock(PdfBuildContext ctx) {
    final lines = ctx.block.split('\n');
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
        children.add(pw.Text(trimmed, style: ctx.styles.normal));
        prevWasUnderline = true;
        isFirstAfterUnderline = true;
      } else if (prevWasUnderline && isFirstAfterUnderline) {
        isFirstAfterUnderline = false;
        final spans = _spans.build(
          trimmed,
          ctx.fields,
          ctx.styles.bold,
          ctx.styles.bold,
          ctx.styles.placeholder,
        );
        children.add(
          pw.RichText(
            textAlign: pw.TextAlign.left,
            text: pw.TextSpan(children: spans),
          ),
        );
      } else if (prevWasUnderline) {
        final spans = _spans.build(
          trimmed,
          ctx.fields,
          ctx.styles.normal,
          ctx.styles.bold,
          ctx.styles.placeholder,
        );
        children.add(
          pw.RichText(
            textAlign: pw.TextAlign.left,
            text: pw.TextSpan(children: spans),
          ),
        );
      } else {
        final spans = _spans.build(
          trimmed,
          ctx.fields,
          ctx.styles.bold,
          ctx.styles.bold,
          ctx.styles.placeholder,
        );
        children.add(
          pw.RichText(
            textAlign: pw.TextAlign.left,
            text: pw.TextSpan(children: spans),
          ),
        );
        prevWasUnderline = false;
        isFirstAfterUnderline = false;
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: children,
    );
  }
}
