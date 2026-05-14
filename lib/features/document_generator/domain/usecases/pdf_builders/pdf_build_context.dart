import '../../entities/field.dart';
import 'pdf_block_type.dart';
import 'pdf_styles.dart';

class PdfBuildContext {
  final String block;
  final List<Field> fields;
  final PdfStyles styles;
  final PdfBlockType blockType;

  const PdfBuildContext({
    required this.block,
    required this.fields,
    required this.styles,
    required this.blockType,
  });

  factory PdfBuildContext.fromBlock({
    required String block,
    required List<Field> fields,
    required PdfStyles styles,
  }) => PdfBuildContext(
    block: block,
    fields: fields,
    styles: styles,
    blockType: PdfBlockType.detect(block),
  );
}
