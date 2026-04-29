import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../provider/settings_provider.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static const _languages = [
    ('en', 'English'),
    ('ur', 'Urdu'),
    ('ar', 'Arabic'),
    ('fr', 'French'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.watch<SettingsProvider>().language;
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: ListView(
        children: _languages
            .map(
              (lang) => ListTile(
                title: Text(lang.$2),
                trailing: current == lang.$1
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  context.read<SettingsProvider>().setLanguage(lang.$1);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
