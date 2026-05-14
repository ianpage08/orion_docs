import 'package:pdf/widgets.dart' as pw;
import '../../entities/field.dart';

class SpanBuilder {
  const SpanBuilder();

  List<pw.InlineSpan> build(
    String templateText,
    List<Field> fields,
    pw.TextStyle normalStyle,
    pw.TextStyle boldStyle,
    pw.TextStyle placeholderStyle,
  ) {
    final spans = <pw.InlineSpan>[];
    final regex = RegExp(r'\{\{(\w+)\}\}');
    int lastEnd = 0;

    for (final match in regex.allMatches(templateText)) {
      if (match.start > lastEnd) {
        spans.add(
          pw.TextSpan(
            text: templateText.substring(lastEnd, match.start),
            style: normalStyle,
          ),
        );
      }

      final fieldId = match.group(1)!;
      final field = fields.firstWhere(
        (f) => f.id == fieldId,
        orElse: () => Field(
          id: fieldId,
          label: fieldId,
          type: FieldType.text,
          required: false,
        ),
      );

      if (field.value.isEmpty) {
        spans.add(
          pw.TextSpan(text: '[${field.label}]', style: placeholderStyle),
        );
      } else {
        spans.add(pw.TextSpan(text: field.value, style: boldStyle));
      }

      lastEnd = match.end;
    }

    if (lastEnd < templateText.length) {
      spans.add(
        pw.TextSpan(text: templateText.substring(lastEnd), style: normalStyle),
      );
    }

    return spans;
  }
}
