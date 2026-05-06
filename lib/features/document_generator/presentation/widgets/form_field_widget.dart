import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../domain/entities/field.dart';
import '../providers/document_providers.dart';

class FormFieldWidget extends ConsumerStatefulWidget {
  final Field field;

  const FormFieldWidget({super.key, required this.field});

  @override
  ConsumerState<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends ConsumerState<FormFieldWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field.value);
  }

  @override
  void didUpdateWidget(FormFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller when field value is reset externally
    if (widget.field.value != _controller.text) {
      _controller.text = widget.field.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    ref.read(formStateProvider.notifier).updateField(widget.field.id, value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: switch (widget.field.type) {
        FieldType.date => _buildDateField(context),
        FieldType.currency => _buildTextField(prefixText: 'R\$ '),
        FieldType.cpf => _buildMaskedField('###.###.###-##'),
        FieldType.phone => _buildMaskedField('(##) #####-####'),
        FieldType.multiline => _buildMultilineField(),
        FieldType.text => _buildTextField(),
      },
    );
  }

  Widget _buildTextField({String? prefixText}) {
    return TextFormField(
      controller: _controller,
      onChanged: _onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: _decoration(prefixText: prefixText),
    );
  }

  Widget _buildMultilineField() {
    return TextFormField(
      controller: _controller,
      onChanged: _onChanged,
      maxLines: 4,
      minLines: 2,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: _decoration(),
    );
  }

  Widget _buildMaskedField(String mask) {
    return TextFormField(
      controller: _controller,
      onChanged: _onChanged,
      inputFormatters: [
        MaskTextInputFormatter(mask: mask, filter: {'#': RegExp(r'\d')}),
      ],
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: _decoration(),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          final formatted =
              '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
          _controller.text = formatted;
          _onChanged(formatted);
        }
      },
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: _decoration(
        suffixIcon: const Icon(
          Icons.calendar_today_rounded,
          size: 18,
          color: Color(0xFF888899),
        ),
      ),
    );
  }

  InputDecoration _decoration({String? prefixText, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: widget.field.label,
      labelStyle: const TextStyle(color: Color(0xFF888899), fontSize: 13),
      prefixText: prefixText,
      prefixStyle: const TextStyle(color: Colors.white, fontSize: 14),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFF252535),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3A3A4A)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3A3A4A)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
