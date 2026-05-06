import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../domain/entities/field.dart';
import '../providers/document_providers.dart';

class FormFieldWidget extends ConsumerStatefulWidget {
  final Field field;
  final int index;

  const FormFieldWidget({super.key, required this.field, required this.index});

  @override
  ConsumerState<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends ConsumerState<FormFieldWidget> {
  late final TextEditingController _controller;
  MaskTextInputFormatter? _maskFormatter;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field.value);
    _maskFormatter = switch (widget.field.type) {
      FieldType.cpf => MaskTextInputFormatter(
          mask: '###.###.###-##',
          filter: {'#': RegExp(r'\d')},
        ),
      FieldType.phone => MaskTextInputFormatter(
          mask: '(##) #####-####',
          filter: {'#': RegExp(r'\d')},
        ),
      _ => null,
    };
  }

  @override
  void didUpdateWidget(FormFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
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

  Icon? _prefixIcon() => switch (widget.field.type) {
        FieldType.text => const Icon(Icons.person_outline, size: 16, color: Color(0xFF555570)),
        FieldType.cpf => const Icon(Icons.badge_outlined, size: 16, color: Color(0xFF555570)),
        FieldType.phone => const Icon(Icons.phone_outlined, size: 16, color: Color(0xFF555570)),
        FieldType.date => null,
        FieldType.currency => const Icon(Icons.attach_money, size: 16, color: Color(0xFF555570)),
        FieldType.multiline => const Icon(Icons.notes_outlined, size: 16, color: Color(0xFF555570)),
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.field.label,
                style: const TextStyle(color: Color(0xFF8888A0), fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '/${widget.index.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Color(0xFF4A4A6A), fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 4),
        switch (widget.field.type) {
          FieldType.date => _buildDateField(context),
          FieldType.currency => _buildTextField(prefixText: 'R\$ '),
          FieldType.cpf => _buildMaskedField(),
          FieldType.phone => _buildMaskedField(),
          FieldType.multiline => _buildMultilineField(),
          FieldType.text => _buildTextField(),
        },
      ],
    );
  }

  Widget _buildTextField({String? prefixText}) {
    return TextFormField(
      controller: _controller,
      onChanged: _onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: _decoration(prefixText: prefixText),
    );
  }

  Widget _buildMultilineField() {
    return TextFormField(
      controller: _controller,
      onChanged: _onChanged,
      maxLines: 3,
      minLines: 2,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: _decoration(),
    );
  }

  Widget _buildMaskedField() {
    return TextFormField(
      controller: _controller,
      onChanged: _onChanged,
      inputFormatters: [if (_maskFormatter != null) _maskFormatter!],
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white, fontSize: 13),
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
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: _decoration(
        suffixIcon: const Icon(
          Icons.calendar_today_rounded,
          size: 16,
          color: Color(0xFF555570),
        ),
      ),
    );
  }

  InputDecoration _decoration({String? prefixText, Widget? suffixIcon}) {
    return InputDecoration(
      prefixIcon: _prefixIcon(),
      prefixText: prefixText,
      prefixStyle: const TextStyle(color: Colors.white, fontSize: 13),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFF0F0F1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2A2A3F)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2A2A3F)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF00BCD4), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
    );
  }
}
