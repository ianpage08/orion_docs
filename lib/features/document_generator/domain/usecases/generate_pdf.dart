import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../entities/document.dart';

class GeneratePdf {
  const GeneratePdf();

  Future<Uint8List> call(Document document) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (_) => [
          pw.Text(
            document.title,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            document.renderedText,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
    return pdf.save();
  }
}
