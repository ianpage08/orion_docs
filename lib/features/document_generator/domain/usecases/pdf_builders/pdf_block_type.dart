enum PdfBlockType {
  clause,
  subClause,
  signature,
  header,
  table,
  paragraph;

  static PdfBlockType detect(String block) {
    if (block.startsWith('[CLAUSULA]')) return PdfBlockType.clause;
    if (block.startsWith('[SUBCLAUSULA]')) return PdfBlockType.subClause;
    if (block.startsWith('[TABELA]')) return PdfBlockType.table;
    if (_isSignature(block)) return PdfBlockType.signature;
    if (_isHeader(block)) return PdfBlockType.header;
    return PdfBlockType.paragraph;
  }

  static bool _isSignature(String block) => block
      .split('\n')
      .any((line) => RegExp(r'^_+$').hasMatch(line.trim()) && line.trim().length >= 5);

  static bool _isHeader(String block) {
    final lines = block.split('\n');
    if (lines.length != 1) return false;
    final line = lines[0].trim();
    return line.isNotEmpty &&
        line.length < 60 &&
        !line.contains('{{') &&
        line.toUpperCase() == line;
  }
}
