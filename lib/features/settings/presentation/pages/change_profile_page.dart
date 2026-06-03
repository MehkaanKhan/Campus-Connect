import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
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
  Uint8List? _pickedBytes;
  bool _isSaving = false;

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => _pickedBytes = bytes);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final success = await context.read<AuthProvider>().updateProfile(
          name: _nameCtrl.text.trim(),
          photoBytes: _pickedBytes,
        );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
      AppSnackbar.show(context, 'Profile updated successfully');
      Navigator.of(context).pop();
    } else {
      AppSnackbar.show(
        context,
        context.read<AuthProvider>().errorMessage ?? 'Failed to update profile',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('Change Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _isSaving ? null : _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: AppColors.primary,
                        backgroundImage: _pickedBytes != null
                            ? MemoryImage(_pickedBytes!)
                            : (user?.avatarUrl != null
                                ? NetworkImage(user!.avatarUrl!) as ImageProvider
                                : null),
                        child: (_pickedBytes == null && user?.avatarUrl == null)
                            ? Text(
                                (user?.name.isNotEmpty == true)
                                    ? user!.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.accent,
                          child: SvgPicture.asset(
                            'assets/icons/icons/camera.svg',
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Tap to change photo',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              AuthTextField(
                label: 'Full Name',
                controller: _nameCtrl,
                prefixIcon: const Icon(Icons.person_outline),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EMAIL',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: AppColors.textLabel,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: user?.email ?? '',
                    readOnly: true,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.textMuted,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: AppColors.pageBg,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.inputBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.inputBorder),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : AuthButton(label: 'Save Changes', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
