import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/entities/exchange_item_entity.dart';
import '../provider/hostellite_provider.dart';

class ListItemBottomSheet extends StatefulWidget {
  const ListItemBottomSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<HostelliteProvider>(),
          child: const ListItemBottomSheet(),
        ),
      );

  @override
  State<ListItemBottomSheet> createState() => _ListItemBottomSheetState();
}

class _ListItemBottomSheetState extends State<ListItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  ItemType _type = ItemType.borrow;
  ItemCondition _condition = ItemCondition.good;
  Uint8List? _imageBytes;
  bool _submitting = false;

  static const _conditions = [
    (ItemCondition.brandNew, 'Brand New'),
    (ItemCondition.likeNew, 'Like New'),
    (ItemCondition.good, 'Good'),
    (ItemCondition.fair, 'Fair'),
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (mounted) setState(() => _imageBytes = bytes);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final item = ExchangeItemEntity(
      id: '',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      type: _type,
      price: _type == ItemType.free
          ? null
          : double.tryParse(_priceCtrl.text.trim()),
      priceUnit: _type == ItemType.rent ? '/day' : null,
      condition: _condition,
      sellerName: '',
      timeAgo: 'Just now',
    );

    final success = await context.read<HostelliteProvider>().listItem(
          item,
          imageBytes: _imageBytes?.toList(),
        );

    if (!mounted) return;
    setState(() => _submitting = false);
    if (success) {
      Navigator.of(context).pop();
      AppSnackbar.show(context, 'Item listed successfully!');
    } else {
      AppSnackbar.show(
        context,
        context.read<HostelliteProvider>().error ?? 'Failed to list item',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h + bottomPad),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'List an Item',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 20.h),

              // Type selector
              _label('TYPE'),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _TypeChip(
                    label: 'Borrow',
                    selected: _type == ItemType.borrow,
                    onTap: () => setState(() => _type = ItemType.borrow),
                  ),
                  SizedBox(width: 8.w),
                  _TypeChip(
                    label: 'Rent',
                    selected: _type == ItemType.rent,
                    onTap: () => setState(() => _type = ItemType.rent),
                  ),
                  SizedBox(width: 8.w),
                  _TypeChip(
                    label: 'Free',
                    selected: _type == ItemType.free,
                    onTap: () => setState(() => _type = ItemType.free),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Title
              _label('TITLE'),
              SizedBox(height: 6.h),
              TextFormField(
                controller: _titleCtrl,
                decoration: _inputDeco(hint: 'e.g. Calculator, Textbook...'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
              ),
              SizedBox(height: 14.h),

              // Description
              _label('DESCRIPTION'),
              SizedBox(height: 6.h),
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: _inputDeco(hint: 'Describe the item...'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Add a description' : null,
              ),
              SizedBox(height: 14.h),

              // Price (hidden for free)
              if (_type != ItemType.free) ...[
                _label(_type == ItemType.rent ? 'PRICE / DAY' : 'PRICE'),
                SizedBox(height: 6.h),
                TextFormField(
                  controller: _priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _inputDeco(hint: '0'),
                  validator: (v) {
                    if (_type == ItemType.free) return null;
                    if (v == null || v.trim().isEmpty) return 'Enter a price';
                    if (double.tryParse(v.trim()) == null) return 'Invalid number';
                    return null;
                  },
                ),
                SizedBox(height: 14.h),
              ],

              // Condition
              _label('CONDITION'),
              SizedBox(height: 6.h),
              DropdownButtonFormField<ItemCondition>(
                initialValue: _condition,
                decoration: _inputDeco(),
                items: _conditions
                    .map((c) => DropdownMenuItem(
                          value: c.$1,
                          child: Text(c.$2,
                              style: const TextStyle(fontFamily: 'Inter')),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _condition = v);
                },
              ),
              SizedBox(height: 14.h),

              // Image picker
              _label('PHOTO (optional)'),
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.pageBg,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: AppColors.inputBorder,
                        style: BorderStyle.solid),
                  ),
                  child: _imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAssets.iconCamera,
                                width: 28.w,
                                height: 28.h,
                                colorFilter: const ColorFilter.mode(
                                    AppColors.textMuted, BlendMode.srcIn)),
                            SizedBox(height: 6.h),
                            Text(
                              'Tap to add photo',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.sp,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 24.h),

              // Submit
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: _submitting
                      ? SizedBox(
                          width: 22.w,
                          height: 22.h,
                          child: const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'List Item',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: AppColors.textLabel,
        ),
      );

  InputDecoration _inputDeco({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint, fontFamily: 'Inter'),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      );
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TypeChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.inputBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
