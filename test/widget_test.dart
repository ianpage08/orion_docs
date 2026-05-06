import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/main.dart';

void main() {
  testWidgets('Sidebar renders with Orion Docs header', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: OrionDocsApp()),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Orion Docs'), findsOneWidget);
    expect(find.text('Selecione um documento'), findsOneWidget);
  });
}
