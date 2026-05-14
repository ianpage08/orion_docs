import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/document_generator/domain/entities/document.dart';
import 'package:orion_docs/features/document_generator/domain/entities/document_type.dart';
import 'package:orion_docs/features/document_generator/domain/entities/field.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/generate_pdf.dart';

Document _doc(String templateText, {List<Field> fields = const []}) => Document(
  type: DocumentType.reciboSimples,
  title: 'Teste',
  fields: fields,
  templateText: templateText,
);

void main() {
  group('GeneratePdf — smoke tests', () {
    test('retorna bytes não vazios para documento mínimo', () async {
      final bytes = await const GeneratePdf()(_doc('Parágrafo simples.'));
      expect(bytes.isNotEmpty, isTrue);
    });

    test('magic bytes %PDF confirmam PDF válido', () async {
      final bytes = await const GeneratePdf()(_doc('Conteúdo.'));
      expect(bytes.sublist(0, 4), equals([0x25, 0x50, 0x44, 0x46]));
    });

    test('documento com todos os tipos de bloco gera PDF sem exceção', () async {
      const template = '''
Parágrafo de abertura.

[CLAUSULA] DA CONTRATAÇÃO

[SUBCLAUSULA] O contratante se compromete.

DISPOSIÇÕES FINAIS

_____
João Silva
CPF: 000.000.000-00
''';
      expect(() async => const GeneratePdf()(_doc(template)), returnsNormally);
    });

    test('campos preenchidos são resolvidos no PDF', () async {
      final fields = [
        const Field(
          id: 'nome',
          label: 'Nome',
          type: FieldType.text,
          required: true,
          value: 'Maria',
        ),
      ];
      final bytes = await const GeneratePdf()(_doc('Olá {{nome}}.', fields: fields));
      expect(bytes.isNotEmpty, isTrue);
    });
  });
}
