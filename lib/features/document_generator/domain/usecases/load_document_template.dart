import '../entities/document.dart';
import '../entities/document_type.dart';
import '../repositories/document_repository.dart';

class LoadDocumentTemplate {
  final DocumentRepository repository;
  const LoadDocumentTemplate(this.repository);

  Future<Document> call(DocumentType type) => repository.loadTemplate(type);
}
