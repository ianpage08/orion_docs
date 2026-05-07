import 'dart:io';
import 'dart:typed_data';

Future<void> downloadPdfImpl(String filename, Uint8List bytes) async {
  final file = File('${Directory.systemTemp.path}/$filename');
  await file.writeAsBytes(bytes, flush: true);
  await Process.run('cmd', ['/c', 'start', '', file.path]);
}
