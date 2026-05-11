import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/sidebar/presentation/widgets/sidebar.dart';

void main() {
  testWidgets('Sidebar renders with Orion Docs header', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Row(children: [AppSidebar()]),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Orion Docs'), findsOneWidget);
  });
}
