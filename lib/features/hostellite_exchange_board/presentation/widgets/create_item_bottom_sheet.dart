import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../hostellite_exchange/domain/entities/exchange_item_entity.dart';
import '../../presentation/provider/exchange_board_provider.dart';
import '../../../hostellite_exchange/presentation/provider/hostellite_provider.dart';

class CreateItemBottomSheet extends StatefulWidget {
  const CreateItemBottomSheet({super.key});

  @override
  State<CreateItemBottomSheet> createState() => _CreateItemBottomSheetState();
}

class _CreateItemBottomSheetState extends State<CreateItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _priceUnitController = TextEditingController();
  final _imageUrlController = TextEditingController();

  ItemType _selectedType = ItemType.borrow;
  ItemCondition _selectedCondition = ItemCondition.good;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _priceUnitController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    final priceText = _priceController.text.trim();
    final priceUnit = _priceUnitController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    double? price;
    if (_selectedType != ItemType.free && priceText.isNotEmpty) {
      price = double.tryParse(priceText);
      if (price == null) {
        setState(() => _error = 'Please enter a valid price amount');
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final provider = context.read<ExchangeBoardProvider>();
      final success = await provider.createExchangeItem(
        title: title,
        description: desc,
        type: _selectedType,
        price: price,
        priceUnit: priceUnit.isNotEmpty ? priceUnit : null,
        condition: _selectedCondition,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      );

      if (success && mounted) {
        // Refresh feed as well
        context.read<HostelliteProvider>().load();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing created successfully')),
        );
        context.pop();
      } else {
        setState(() {
          _error = provider.error ?? 'Failed to publish listing';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Exchange Listing',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20.sp,
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
              SizedBox(height: 12.h),
              if (_error != null) ...[
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
              ],
              _buildTextField(
                controller: _titleController,
                hint: 'Item Title',
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a title' : null,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _descController,
                hint: 'Description',
                maxLines: 3,
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown<ItemType>(
                      label: 'Type',
                      value: _selectedType,
                      items: const [
                        DropdownMenuItem(value: ItemType.borrow, child: Text('Borrow')),
                        DropdownMenuItem(value: ItemType.rent, child: Text('Rent')),
                        DropdownMenuItem(value: ItemType.free, child: Text('Giveaway')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedType = val;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildDropdown<ItemCondition>(
                      label: 'Condition',
                      value: _selectedCondition,
                      items: const [
                        DropdownMenuItem(value: ItemCondition.brandNew, child: Text('Brand New')),
                        DropdownMenuItem(value: ItemCondition.likeNew, child: Text('Like New')),
                        DropdownMenuItem(value: ItemCondition.good, child: Text('Good')),
                        DropdownMenuItem(value: ItemCondition.fair, child: Text('Fair')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedCondition = val;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              if (_selectedType != ItemType.free) ...[
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        controller: _priceController,
                        hint: 'Price (Rs.)',
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (_selectedType != ItemType.free && (val == null || val.trim().isEmpty)) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        controller: _priceUnitController,
                        hint: 'Price Unit (e.g. /mo, /day, /ea)',
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _imageUrlController,
                hint: 'Image URL (optional)',
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
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Publish Listing',
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
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
        filled: true,
        fillColor: AppColors.pageBg,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
            filled: true,
            fillColor: AppColors.pageBg,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
      ],
    );
  }
}
