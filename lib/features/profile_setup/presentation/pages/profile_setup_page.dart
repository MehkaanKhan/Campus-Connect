import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../provider/profile_setup_provider.dart';

// ─────────────────────────────────────────────────────────
// Design reference colours (from profile-setup.png)
// Background : #1C1C1C  (near-black)
// Card bg    : #F5F5F0  (warm off-white)
// Green CTA  : #6B8F6B  (muted sage green)
// Progress   : #6B8F6B fill on #E0E0D8 track
// Label txt  : #5A5A5A  (small caps labels)
// Input bdr  : #DCDCD4
// ─────────────────────────────────────────────────────────

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 80, // Account for vertical padding
                ),
                child: Center(
                  child: _ProfileCard(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  The white card
// ─────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileSetupProvider>();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F0),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Step header row ──
          _StepHeader(),
          const SizedBox(height: 16),

          // ── Progress bar ──
          _ProgressBar(currentStep: 2, totalSteps: 3),
          const SizedBox(height: 18),

          // ── Title ──
          const Text(
            'Tell us about\nyourself',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.25,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),

          // ── Subtitle ──
          const Text(
            'This information helps us personalize\nyour CampusOS experience.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Color(0xFF777770),
            ),
          ),
          const SizedBox(height: 16),

          // ── Profile photo ──
          const _SectionLabel('PROFILE PHOTO'),
          const SizedBox(height: 10),
          _PhotoUploadButton(photoPath: provider.photoPath),
          const SizedBox(height: 14),

          // ── Full name ──
          const _SectionLabel('FULL NAME'),
          const SizedBox(height: 8),
          _NameField(
            onChanged: provider.setFullName,
          ),
          const SizedBox(height: 18),

          // ── Department ──
          const _SectionLabel('DEPARTMENT'),
          const SizedBox(height: 8),
          _DropdownField(
            hint: 'Select Department',
            value: provider.selectedDepartment,
            items: provider.departments,
            onChanged: provider.setDepartment,
          ),
          const SizedBox(height: 18),

          // ── Semester ──
          const _SectionLabel('SEMESTER'),
          const SizedBox(height: 8),
          _DropdownField(
            hint: 'Select Semester',
            value: provider.selectedSemester,
            items: provider.semesters,
            onChanged: provider.setSemester,
          ),
          const SizedBox(height: 20),

          // ── Next Step button ──
          _NextStepButton(
            isLoading: provider.status == ProfileSetupStatus.loading,
            onTap: () async {
              await provider.saveProfile();
              if (context.mounted &&
                  provider.status == ProfileSetupStatus.success) {
                context.go('/thread');
              }
            },
          ),
          const SizedBox(height: 12),

          // ── Back button ──
          _BackButton(onTap: () => context.go('/onboarding')),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Step header  ("STEP 2 OF 3"  •  "Save & Exit ✕")
// ─────────────────────────────────────────────────────────
class _StepHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'STEP 2 OF 3',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: Color(0xFF888880),
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/login'),
          child: const Row(
            children: [
              Text(
                'Save & Exit',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF555550),
                ),
              ),
              SizedBox(width: 4),
              Text(
                '✕',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF555550),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Progress bar
// ─────────────────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _ProgressBar({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: currentStep / totalSteps,
        minHeight: 5,
        backgroundColor: const Color(0xFFE0E0D8),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6B8F6B)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Small-caps section label
// ─────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Color(0xFF888880),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Circular photo upload button
// ─────────────────────────────────────────────────────────
class _PhotoUploadButton extends StatelessWidget {
  final String? photoPath;
  const _PhotoUploadButton({this.photoPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // TODO: image picker integration
          },
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFECECE8),
              border: Border.all(
                color: const Color(0xFFD0D0C8),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.photo_camera_outlined,
              size: 28,
              color: Color(0xFF999990),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload Photo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF555550),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'JPG, GIF or PNG. Max 800K.',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF999990),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Full name text field
// ─────────────────────────────────────────────────────────
class _NameField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _NameField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF1A1A1A),
      ),
      decoration: InputDecoration(
        hintText: 'Jane Doe',
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFFAAAAAA),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDCDCD4), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6B8F6B), width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Dropdown field
// ─────────────────────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDCDCD4), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFAAAAAA),
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF888880),
            size: 20,
          ),
          isExpanded: true,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1A1A1A),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(8),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Next Step button
// ─────────────────────────────────────────────────────────
class _NextStepButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _NextStepButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF6B8F6B),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Next Step →',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Back button
// ─────────────────────────────────────────────────────────
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFECECE8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            '← Back',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF555550),
            ),
          ),
        ),
      ),
    );
  }
}
