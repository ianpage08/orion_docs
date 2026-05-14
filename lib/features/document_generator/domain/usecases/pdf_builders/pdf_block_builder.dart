import 'package:pdf/widgets.dart' as pw;
import 'pdf_block_type.dart';
import 'pdf_build_context.dart';

abstract interface class PdfBlockBuilder {
  bool canHandle(PdfBlockType blockType);
  ({pw.Widget widget, double spaceBefore}) build(PdfBuildContext context);
}
