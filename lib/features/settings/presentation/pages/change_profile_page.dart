import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../auth/presentation/widgets/auth_button.dart';
import '../../../auth/presentation/widgets/auth_textfield.dart';

class ChangeProfilePage extends StatefulWidget {
  const ChangeProfilePage({super.key});

  @override
  State<ChangeProfilePage> createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      AppSnackbar.show(context, 'Profile updated successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 52,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, size: 52, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.accent,
                        child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AuthTextField(
                label: 'Full Name',
                controller: _nameCtrl,
                prefixIcon: const Icon(Icons.person_outline),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Email',
                controller: TextEditingController(
                    text: context.read<AuthProvider>().user?.email ?? ''),
                prefixIcon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              AuthButton(label: 'Save Changes', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
