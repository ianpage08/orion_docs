import '../entities/document.dart';

class UpdateFieldValue {
  const UpdateFieldValue();

  Document call(Document document, String fieldId, String value) {
    final updated = document.fields
        .map((f) => f.id == fieldId ? f.copyWith(value: value) : f)
        .toList();
    return document.copyWith(fields: updated);
  }
}
