import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/document_providers.dart';
import 'form_field_widget.dart';
import 'generate_button.dart';
import 'clear_button.dart';

class DynamicFormBuilder extends ConsumerWidget {
  const DynamicFormBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(formStateProvider);

    if (document == null) {
      return const ColoredBox(
        color: Color(0xFF1E1E2E),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
        ),
      );
    }

    return ColoredBox(
      color: const Color(0xFF1E1E2E),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  document.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ...document.fields.map(
                  (field) =>
                      FormFieldWidget(key: ValueKey(field.id), field: field),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A2A),
              border: Border(top: BorderSide(color: Color(0xFF3A3A4A))),
            ),
            child: const Row(
              children: [
                Expanded(child: GenerateButton()),
                SizedBox(width: 12),
                ClearButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
