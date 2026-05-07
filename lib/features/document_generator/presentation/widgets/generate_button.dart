import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/generate_pdf.dart';
import '../providers/document_providers.dart';
import '../../../../core/platform/pdf_downloader.dart';

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
      final safeTitle = document.title.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
      await downloadPdf('$safeTitle.pdf', bytes);
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isGenerating ? null : _generate,
      icon: _isGenerating
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.download_rounded, size: 18),
      label: const Text(
        'GERAR PDF',
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.8),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        disabledBackgroundColor: const Color(0xFF006080),
      ),
    );
  }
}
