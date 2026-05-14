import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:orion_docs/features/document_generator/domain/entities/field.dart';
import 'package:orion_docs/features/document_generator/domain/usecases/pdf_builders/span_builder.dart';

void main() {
  final normalStyle = pw.TextStyle(font: pw.Font.helvetica(), fontSize: 12);
  final boldStyle = pw.TextStyle(
    font: pw.Font.helveticaBold(),
    fontSize: 12,
    fontWeight: pw.FontWeight.bold,
  );
  final placeholderStyle = pw.TextStyle(font: pw.Font.helvetica(), fontSize: 12);
  const builder = SpanBuilder();

  Field field({String id = 'nome', String label = 'Nome', String value = ''}) =>
      Field(id: id, label: label, type: FieldType.text, required: false, value: value);

  group('SpanBuilder — texto sem campos', () {
    test('retorna um único span com o texto completo', () {
      final spans = builder.build('Olá mundo', [], normalStyle, boldStyle, placeholderStyle);
      expect(spans.length, 1);
      expect((spans[0] as pw.TextSpan).text, 'Olá mundo');
    });
  });

  group('SpanBuilder — campo vazio', () {
    test('gera span placeholder com label entre colchetes', () {
      final spans = builder.build(
        'Ola {{nome}}!',
        [field()],
        normalStyle,
        boldStyle,
        placeholderStyle,
      );
      expect(spans.length, 3);
      expect((spans[1] as pw.TextSpan).text, '[Nome]');
    });

    test('campo inexistente usa o próprio id como label', () {
      final spans = builder.build(
        '{{desconhecido}}',
        [],
        normalStyle,
        boldStyle,
        placeholderStyle,
      );
      expect((spans[0] as pw.TextSpan).text, '[desconhecido]');
    });
  });

  group('SpanBuilder — campo preenchido', () {
    test('gera span bold com o valor do campo', () {
      final spans = builder.build(
        'Sr. {{nome}}',
        [field(value: 'João')],
        normalStyle,
        boldStyle,
        placeholderStyle,
      );
      expect(spans.length, 2);
      expect((spans[1] as pw.TextSpan).text, 'João');
      expect((spans[1] as pw.TextSpan).style, boldStyle);
    });
  });

  group('SpanBuilder — múltiplos campos', () {
    test('resolve todos os campos na ordem correta', () {
      final spans = builder.build(
        '{{a}} e {{b}}',
        [field(id: 'a', label: 'A', value: 'X'), field(id: 'b', label: 'B', value: 'Y')],
        normalStyle,
        boldStyle,
        placeholderStyle,
      );
      expect((spans[0] as pw.TextSpan).text, 'X');
      expect((spans[1] as pw.TextSpan).text, ' e ');
      expect((spans[2] as pw.TextSpan).text, 'Y');
    });
  });
}
