import 'package:pdf/widgets.dart' as pw;
import 'pdf_block_builder.dart';
import 'pdf_block_type.dart';
import 'pdf_build_context.dart';

class TableBuilder implements PdfBlockBuilder {
  const TableBuilder();

  @override
  bool canHandle(PdfBlockType blockType) => blockType == PdfBlockType.table;

  @override
  ({pw.Widget widget, double spaceBefore}) build(PdfBuildContext context) =>
      (widget: pw.SizedBox(), spaceBefore: 0.0);
}
