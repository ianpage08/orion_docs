import '../../domain/entities/field.dart';

class FieldModel {
  final String id;
  final String label;
  final String type;
  final bool required;

  const FieldModel({
    required this.id,
    required this.label,
    required this.type,
    required this.required,
  });

  factory FieldModel.fromJson(Map<String, dynamic> json) => FieldModel(
        id: json['id'] as String,
        label: json['label'] as String,
        type: json['type'] as String,
        required: json['required'] as bool,
      );

  Field toDomain() => Field(
        id: id,
        label: label,
        type: _parseFieldType(type),
        required: required,
      );

  static FieldType _parseFieldType(String type) => switch (type) {
        'date' => FieldType.date,
        'currency' => FieldType.currency,
        'cpf' => FieldType.cpf,
        'phone' => FieldType.phone,
        'multiline' => FieldType.multiline,
        _ => FieldType.text,
      };
}
