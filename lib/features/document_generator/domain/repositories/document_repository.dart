import '../entities/document.dart';
import '../entities/document_type.dart';

abstract class DocumentRepository {
  Future<Document> loadTemplate(DocumentType type);
}
