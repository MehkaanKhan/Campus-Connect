import 'package:flutter/material.dart';

class AuthHeading extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AuthHeading({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.w900,
            height: 1.15,
            letterSpacing: -0.5,
            color: Color(0xFF1A1A1A),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Color(0xFF555555),
            ),
          ),
        ],
      ],
    );
  }
}
