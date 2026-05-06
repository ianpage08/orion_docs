import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/document_providers.dart';

class PreviewPanel extends ConsumerWidget {
  const PreviewPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(formStateProvider);

    if (document == null) {
      return const ColoredBox(
        color: Color(0xFFF5F5F0),
        child: Center(
          child: Text(
            'Preencha o formulário para visualizar',
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return ColoredBox(
      color: const Color(0xFFF5F5F0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document.title,
              style: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              document.renderedText,
              style: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 12,
                fontFamily: 'monospace',
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
