import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../provider/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_heading.dart';
import '../widgets/auth_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<AuthProvider>();
    await provider.login(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);
    if (!mounted) return;
    if (provider.isAuthenticated) {
      context.go('/thread');
    } else if (provider.errorMessage != null) {
      AppSnackbar.show(context, provider.errorMessage!, isError: true);
      provider.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.school, size: 72, color: AppColors.primary),
                const SizedBox(height: 24),
                const AuthHeading(
                  title: 'Welcome back',
                  subtitle: 'Sign in to your Campus Connect account',
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
                const SizedBox(height: 16),
                AuthTextField(
                  label: 'Password',
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter your password' : null,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/reset-password'),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 16),
                AuthButton(label: 'Login', onPressed: _submit, isLoading: isLoading),
                const SizedBox(height: 12),
                AuthButton(
                  label: 'Create Account',
                  onPressed: () => context.go('/signup'),
                  outlined: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
