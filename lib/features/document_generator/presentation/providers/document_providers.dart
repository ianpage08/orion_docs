import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/document.dart';
import '../../domain/entities/document_type.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/usecases/load_document_template.dart';
import '../../domain/usecases/update_field_value.dart';
import '../../data/datasources/local_template_datasource.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../../sidebar/presentation/controllers/sidebar_controller.dart';

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return const DocumentRepositoryImpl(LocalTemplateDatasource());
});

final selectedDocumentTypeProvider = Provider<DocumentType?>((ref) {
  final activeId = ref.watch(sidebarControllerProvider).activeItemId;
  return _idToDocumentType(activeId);
});

final documentTemplateProvider = FutureProvider.autoDispose
    .family<Document, DocumentType>((ref, type) async {
  final repo = ref.read(documentRepositoryProvider);
  return LoadDocumentTemplate(repo)(type);
});

final formStateProvider = NotifierProvider.autoDispose<FormStateNotifier, Document?>(
  FormStateNotifier.new,
);

class FormStateNotifier extends AutoDisposeNotifier<Document?> {
  @override
  Document? build() => null;

  void loadDocument(Document doc) => state = doc;

  void updateField(String fieldId, String value) {
    final current = state;
    if (current == null) return;
    state = const UpdateFieldValue()(current, fieldId, value);
  }

  void reset() {
    final current = state;
    if (current == null) return;
    state = current.copyWith(
      fields: current.fields.map((f) => f.copyWith(value: '')).toList(),
    );
  }
}

DocumentType? _idToDocumentType(String? id) => switch (id) {
      'contrato_aluguel' => DocumentType.contratoAluguel,
      'contrato_compra_venda' => DocumentType.contratoCompraVenda,
      'contrato_doacao' => DocumentType.contratoDoacao,
      'recibo_simples' => DocumentType.reciboSimples,
      'recibo_aluguel' => DocumentType.reciboAluguel,
      'conformidade_sonora' => DocumentType.conformidadeSonora,
      'baixo_impacto' => DocumentType.baixoImpacto,
      'ligacao_nova' => DocumentType.ligacaoNova,
      'alteracao_titularidade' => DocumentType.alteracaoTitularidade,
      _ => null,
    };
