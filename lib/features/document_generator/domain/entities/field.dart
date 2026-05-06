enum FieldType { text, date, currency, cpf, phone, multiline }

class Field {
  final String id;
  final String label;
  final FieldType type;
  final bool required;
  final String value;

  const Field({
    required this.id,
    required this.label,
    required this.type,
    required this.required,
    this.value = '',
  });

  Field copyWith({String? value}) => Field(
        id: id,
        label: label,
        type: type,
        required: required,
        value: value ?? this.value,
      );
}
