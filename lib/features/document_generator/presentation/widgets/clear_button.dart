import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/document_providers.dart';

class ClearButton extends ConsumerWidget {
  const ClearButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: () => ref.read(formStateProvider.notifier).reset(),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF3A3A4A)),
        foregroundColor: const Color(0xFFAAAAAA),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('Limpar'),
    );
  }
}
