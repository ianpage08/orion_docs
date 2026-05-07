import 'dart:typed_data';
import 'pdf_downloader_stub.dart'
    if (dart.library.html) 'pdf_downloader_web.dart'
    if (dart.library.io) 'pdf_downloader_io.dart';

Future<void> downloadPdf(String filename, Uint8List bytes) =>
    downloadPdfImpl(filename, bytes);
