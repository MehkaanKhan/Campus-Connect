import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../provider/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_heading.dart';
import '../widgets/auth_textfield.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<AuthProvider>();
    final success = await provider.resetPassword(email: _emailCtrl.text.trim());
    if (!mounted) return;
    if (success) {
      AppSnackbar.show(context, 'Password reset email sent. Check your inbox.');
      context.go('/login');
    } else if (provider.errorMessage != null) {
      AppSnackbar.show(context, provider.errorMessage!, isError: true);
      provider.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeading(
                  title: 'Forgot your password?',
                  subtitle: "Enter your email and we'll send you a reset link.",
                ),
                const SizedBox(height: 32),
                AuthTextField(
                  label: 'Email',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AuthButton(label: 'Send Reset Link', onPressed: _submit, isLoading: isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
