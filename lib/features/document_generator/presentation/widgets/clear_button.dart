import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/document_providers.dart';

class ClearButton extends ConsumerWidget {
  const ClearButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () {
        final documentType = ref.read(selectedDocumentTypeProvider);
        if (documentType == null) return;
        ref.read(formStateProvider(documentType).notifier).reset();
      },
      icon: const Icon(Icons.refresh_rounded, size: 16),
      label: const Text('Limpar campos'),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF2A2A3F)),
        foregroundColor: const Color(0xFFAAAAAA),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
