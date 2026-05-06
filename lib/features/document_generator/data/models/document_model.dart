import '../../domain/entities/document.dart';
import '../../domain/entities/document_type.dart';
import 'field_model.dart';

class DocumentModel {
  final String id;
  final String title;
  final List<FieldModel> fields;
  final String template;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.fields,
    required this.template,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        id: json['id'] as String,
        title: json['title'] as String,
        fields: (json['fields'] as List<dynamic>)
            .map((f) => FieldModel.fromJson(f as Map<String, dynamic>))
            .toList(),
        template: json['template'] as String,
      );

  Document toDomain(DocumentType type) => Document(
        type: type,
        title: title,
        fields: fields.map((f) => f.toDomain()).toList(),
        templateText: template,
      );
}
