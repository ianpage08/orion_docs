import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/document.dart';
import '../../domain/entities/document_type.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/usecases/load_document_template.dart';
import '../../domain/usecases/update_field_value.dart';
import '../../data/datasources/local_template_datasource.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../../sidebar/presentation/controllers/sidebar_controller.dart';
import '../mappers/document_type_mapper.dart';

// ── Infraestrutura ────────────────────────────────────────────────────────────

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return const DocumentRepositoryImpl(LocalTemplateDatasource());
});

// ── Use Cases (injetados, nunca instanciados inline) ──────────────────────────

final loadDocumentTemplateProvider = Provider<LoadDocumentTemplate>((ref) {
  return LoadDocumentTemplate(ref.watch(documentRepositoryProvider));
});

final updateFieldValueProvider = Provider<UpdateFieldValue>(
  (_) => const UpdateFieldValue(),
);

// ── Providers de domínio ──────────────────────────────────────────────────────

final selectedDocumentTypeProvider = Provider<DocumentType?>((ref) {
  final activeId = ref.watch(sidebarControllerProvider).activeItemId;
  return DocumentTypeMapper.fromSidebarId(activeId);
});

final documentTemplateProvider = FutureProvider.autoDispose
    .family<Document, DocumentType>((ref, type) {
  return ref.watch(loadDocumentTemplateProvider)(type);
});

// ── Estado do formulário ──────────────────────────────────────────────────────
//
// Family por DocumentType garante:
//   • Nunca existe instância sem tipo — elimina o AsyncLoading eterno (Bug #1)
//   • Cada documento tem estado isolado — sem perda de edições em rebuilds (Bug #2)

final formStateProvider = NotifierProvider.autoDispose
    .family<FormStateNotifier, AsyncValue<Document>, DocumentType>(
  FormStateNotifier.new,
);

class FormStateNotifier
    extends AutoDisposeFamilyNotifier<AsyncValue<Document>, DocumentType> {
  @override
  AsyncValue<Document> build(DocumentType arg) {
    return ref.watch(documentTemplateProvider(arg));
  }

  void updateField(String fieldId, String value) {
    final current = state.valueOrNull;
    if (current == null) return;
    final useCase = ref.read(updateFieldValueProvider);
    state = AsyncData(useCase(current, fieldId, value));
  }

  void reset() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        fields: current.fields.map((f) => f.copyWith(value: '')).toList(),
      ),
    );
  }
}
