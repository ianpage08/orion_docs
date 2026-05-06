import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../domain/usecases/generate_pdf.dart';
import '../providers/document_providers.dart';

class GenerateButton extends ConsumerStatefulWidget {
  const GenerateButton({super.key});

  @override
  ConsumerState<GenerateButton> createState() => _GenerateButtonState();
}

class _GenerateButtonState extends ConsumerState<GenerateButton> {
  bool _isGenerating = false;

  Future<void> _generate() async {
    final document = ref.read(formStateProvider);
    if (document == null) return;

    setState(() => _isGenerating = true);
    try {
      final Uint8List bytes = await const GeneratePdf()(document);
      await Printing.layoutPdf(onLayout: (_) => bytes);
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isGenerating ? null : _generate,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        disabledBackgroundColor: const Color(0xFF4A4460),
      ),
      child: _isGenerating
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Gerar PDF'),
    );
  }
}
