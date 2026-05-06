import 'package:flutter/material.dart';

class TemplateNotAvailableWidget extends StatelessWidget {
  const TemplateNotAvailableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF1E1E2E),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 48,
              color: Color(0xFF555566),
            ),
            SizedBox(height: 16),
            Text(
              'Em desenvolvimento',
              style: TextStyle(
                color: Color(0xFF888899),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Este modelo ainda não está disponível.',
              style: TextStyle(
                color: Color(0xFF555566),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
