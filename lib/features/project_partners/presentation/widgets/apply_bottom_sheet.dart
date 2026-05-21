import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/project_partners_provider.dart';

class ApplyBottomSheet extends StatefulWidget {
  final String listingId;
  final String projectTitle;

  const ApplyBottomSheet({
    super.key,
    required this.listingId,
    required this.projectTitle,
  });

  @override
  State<ApplyBottomSheet> createState() => _ApplyBottomSheetState();
}

class _ApplyBottomSheetState extends State<ApplyBottomSheet> {
  final _messageController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _messageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final message = _messageController.text.trim();
    final phone = _phoneController.text.trim();

    if (message.isEmpty) {
      setState(() => _error = 'Please provide a cover message.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final provider = context.read<ProjectPartnersProvider>();
      await provider.applyToProject(widget.listingId, message, phoneNumber: phone);
      if (mounted) {
        context.pop(); // Close sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully!')),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to submit application. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Apply to Project',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => context.pop(),
              )
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            widget.projectTitle,
            style: TextStyle(
              color: AppColors.textCaption,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          if (_error != null) ...[
            Text(_error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
          ],
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15.sp),
            decoration: InputDecoration(
              hintText: 'Phone number (optional)',
              hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
              filled: true,
              fillColor: AppColors.pageBg,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.border, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.border, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _messageController,
            maxLines: 4,
            maxLength: 500,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15.sp),
            decoration: InputDecoration(
              hintText: 'Introduce yourself and explain why you are a good fit for this project...',
              hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
              filled: true,
              fillColor: AppColors.pageBg,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.border, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.border, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      'Submit Application',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
