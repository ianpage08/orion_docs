import 'field.dart';
import 'document_type.dart';

class Document {
  final DocumentType type;
  final String title;
  final List<Field> fields;
  final String templateText;

  const Document({
    required this.type,
    required this.title,
    required this.fields,
    required this.templateText,
  });

  Document copyWith({List<Field>? fields}) => Document(
        type: type,
        title: title,
        fields: fields ?? this.fields,
        templateText: templateText,
      );

  String get renderedText {
    var text = templateText;
    for (final field in fields) {
      text = text.replaceAll(
        '{{${field.id}}}',
        field.value.isEmpty ? '[${field.label}]' : field.value,
      );
    }
    return text;
  }
}
