import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfStyles {
  static const double _fontSize = 12.0;
  static const double _titleFontSize = 14.0;

  final pw.TextStyle normal;
  final pw.TextStyle bold;
  final pw.TextStyle title;
  final pw.TextStyle placeholder;
  final pw.TextStyle footer;

  const PdfStyles({
    required this.normal,
    required this.bold,
    required this.title,
    required this.placeholder,
    required this.footer,
  });

  factory PdfStyles.defaults() {
    final normalFont = pw.Font.helvetica();
    final boldFont = pw.Font.helveticaBold();
    return PdfStyles(
      normal: pw.TextStyle(font: normalFont, fontSize: _fontSize),
      bold: pw.TextStyle(
        font: boldFont,
        fontSize: _fontSize,
        fontWeight: pw.FontWeight.bold,
      ),
      title: pw.TextStyle(
        font: boldFont,
        fontSize: _titleFontSize,
        fontWeight: pw.FontWeight.bold,
      ),
      placeholder: pw.TextStyle(
        font: normalFont,
        fontSize: _fontSize,
        color: PdfColors.grey,
      ),
      footer: pw.TextStyle(
        font: normalFont,
        fontSize: 8.0,
        color: PdfColors.grey600,
      ),
    );
  }
}
