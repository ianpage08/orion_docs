import '../../domain/entities/document.dart';
import '../../domain/entities/document_type.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/local_template_datasource.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final LocalTemplateDatasource _datasource;

  const DocumentRepositoryImpl(this._datasource);

  @override
  Future<Document> loadTemplate(DocumentType type) async {
    final model = await _datasource.loadTemplate(type);
    return model.toDomain(type);
  }
}
