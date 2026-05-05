import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

class CampusTopNavBar extends StatelessWidget {
  final VoidCallback? onBack;

  const CampusTopNavBar({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (onBack != null) ...[
              GestureDetector(
                onTap: onBack,
                child: const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppAssets.headerLogo, width: 24, height: 24),
                const SizedBox(width: 10),
                const Text(
                  'Campus Connect',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(AppAssets.searchIcon, width: 24, height: 24),
          ],
        ),
      ),
    );
  }
}
