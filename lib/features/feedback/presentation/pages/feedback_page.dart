import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../widgets/feedback_success_dialog.dart';

enum _FeedbackType { bug, suggestion }

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  _FeedbackType? _selectedType;
  bool _descriptionEmpty = true;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      final empty = _descriptionController.text.trim().isEmpty;
      if (empty != _descriptionEmpty) setState(() => _descriptionEmpty = empty);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _selectedType != null && !_descriptionEmpty;

  void _submit() {
    if (!_canSubmit) return;
    if (_formKey.currentState?.validate() != true) return;
    final isBug = _selectedType == _FeedbackType.bug;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => FeedbackSuccessDialog(isBug: isBug),
    ).then((_) => _resetForm());
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _subjectController.clear();
    _descriptionController.clear();
    setState(() => _selectedType = null);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        AppSpacing.xxxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(isDark: isDark),
              const SizedBox(height: AppSpacing.xxl),
              _TypeSelector(
                selected: _selectedType,
                isDark: isDark,
                onSelect: (t) => setState(() => _selectedType = t),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Seu nome', optional: true, isDark: isDark),
                    const SizedBox(height: AppSpacing.xs),
                    _FeedbackField(
                      controller: _nameController,
                      icon: Icons.person_outline,
                      hint: 'Como podemos te chamar? (opcional)',
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _FieldLabel('Assunto', isDark: isDark),
                    const SizedBox(height: AppSpacing.xs),
                    _FeedbackField(
                      controller: _subjectController,
                      icon: Icons.title,
                      hint: 'Resumo do que você quer reportar',
                      isDark: isDark,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Informe o assunto' : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _FieldLabel('Descrição', isDark: isDark),
                    const SizedBox(height: AppSpacing.xs),
                    _FeedbackField(
                      controller: _descriptionController,
                      icon: Icons.notes,
                      hint: 'Descreva com detalhes o problema ou a sugestão...',
                      isDark: isDark,
                      minLines: 4,
                      maxLines: 8,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Descreva o problema ou sugestão' : null,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: _canSubmit
                              ? AppColors.textActive
                              : (isDark ? AppColors.sidebarBorder : AppColors.lightSidebarBorder),
                          foregroundColor: _canSubmit
                              ? Colors.white
                              : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md + 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.itemRadius),
                          ),
                        ),
                        onPressed: _canSubmit ? _submit : null,
                        child: Text(
                          'Enviar',
                          style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isDark;
  const _Header({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.textActive.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.bug_report_outlined, color: AppColors.textActive, size: 22),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reportar Bug / Sugestões',
              style: AppTypography.headline.copyWith(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Sua opinião nos ajuda a melhorar o Orion Docs',
              style: AppTypography.body.copyWith(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final _FeedbackType? selected;
  final bool isDark;
  final ValueChanged<_FeedbackType> onSelect;

  const _TypeSelector({
    required this.selected,
    required this.isDark,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TypeCard(
            label: 'Reportar Bug',
            icon: Icons.bug_report_outlined,
            isSelected: selected == _FeedbackType.bug,
            isDark: isDark,
            onTap: () => onSelect(_FeedbackType.bug),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _TypeCard(
            label: 'Sugerir Melhoria',
            icon: Icons.lightbulb_outline,
            isSelected: selected == _FeedbackType.suggestion,
            isDark: isDark,
            onTap: () => onSelect(_FeedbackType.suggestion),
          ),
        ),
      ],
    );
  }
}

class _TypeCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _TypeCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_TypeCard> createState() => _TypeCardState();
}

class _TypeCardState extends State<_TypeCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isSelected
        ? AppColors.textActive
        : _hovered
            ? AppColors.textActive.withValues(alpha: 0.4)
            : (widget.isDark ? AppColors.sidebarBorder : AppColors.lightSidebarBorder);

    final bgColor = widget.isSelected
        ? AppColors.textActive.withValues(alpha: 0.08)
        : _hovered
            ? AppColors.textActive.withValues(alpha: 0.04)
            : const Color(0xFF0F0F1E);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                color: widget.isSelected ? AppColors.textActive : AppColors.textMuted,
                size: 28,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.label,
                style: AppTypography.body.copyWith(
                  color: widget.isSelected
                      ? AppColors.textActive
                      : (widget.isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool optional;
  final bool isDark;

  const _FieldLabel(this.text, {this.optional = false, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: AppTypography.caption.copyWith(
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            letterSpacing: 0.4,
          ),
        ),
        if (optional) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            '(opcional)',
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _FeedbackField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool isDark;
  final int minLines;
  final int maxLines;
  final String? Function(String?)? validator;

  const _FeedbackField({
    required this.controller,
    required this.icon,
    required this.hint,
    required this.isDark,
    this.minLines = 1,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? AppColors.sidebarBorder : AppColors.lightSidebarBorder;

    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      style: AppTypography.body.copyWith(
        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
      ),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.body.copyWith(
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.sm),
          child: Icon(icon, color: AppColors.textMuted, size: 18),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: const Color(0xFF0F0F1E),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.textActive, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
