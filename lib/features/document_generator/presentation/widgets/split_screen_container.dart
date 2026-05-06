import 'package:flutter/material.dart';

class SplitScreenContainer extends StatelessWidget {
  final Widget formPanel;
  final Widget previewPanel;

  const SplitScreenContainer({
    super.key,
    required this.formPanel,
    required this.previewPanel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: formPanel),
        const VerticalDivider(
          width: 1,
          thickness: 1,
          color: Color(0xFF3A3A4A),
        ),
        Expanded(flex: 3, child: previewPanel),
      ],
    );
  }
}
