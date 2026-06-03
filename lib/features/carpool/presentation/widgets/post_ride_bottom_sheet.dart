import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/entities/carpool_ride_entity.dart';
import '../provider/carpool_provider.dart';

class PostRideBottomSheet extends StatefulWidget {
  const PostRideBottomSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<CarpoolProvider>(),
        child: const PostRideBottomSheet(),
      ),
    );
    return result ?? false;
  }

  @override
  State<PostRideBottomSheet> createState() => _PostRideBottomSheetState();
}

class _PostRideBottomSheetState extends State<PostRideBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _etaCtrl = TextEditingController();
  int _seats = 3;
  CarpoolFilter _slot = CarpoolFilter.morning;
  bool _submitting = false;

  static const _slots = [
    (CarpoolFilter.morning, 'Morning'),
    (CarpoolFilter.evening, 'Evening'),
    (CarpoolFilter.weekend, 'Weekend'),
  ];

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _timeCtrl.dispose();
    _dateCtrl.dispose();
    _etaCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null || !mounted) return;
    _timeCtrl.text = picked.format(context);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked == null) return;
    final label = picked.day == now.day &&
            picked.month == now.month &&
            picked.year == now.year
        ? 'Today'
        : picked.day == now.day + 1
            ? 'Tomorrow'
            : '${picked.day}/${picked.month}/${picked.year}';
    _dateCtrl.text = label;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final ride = CarpoolRideEntity(
      id: '',
      from: _fromCtrl.text.trim(),
      to: _toCtrl.text.trim(),
      time: _timeCtrl.text.trim(),
      date: _dateCtrl.text.trim(),
      totalSeats: _seats,
      takenSeats: 0,
      driverName: '',
      estimatedMinutes: int.tryParse(_etaCtrl.text.trim()) ?? 0,
      filter: _slot,
    );

    final success = await context.read<CarpoolProvider>().postRide(ride);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      Navigator.of(context).pop(true);
      AppSnackbar.show(context, 'Ride posted successfully!');
    } else {
      AppSnackbar.show(
        context,
        context.read<CarpoolProvider>().error ?? 'Failed to post ride',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomPad),
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
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Post a Ride',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // From / To row
              Row(
                children: [
                  Expanded(
                    child: _field(
                      label: 'FROM',
                      controller: _fromCtrl,
                      hint: 'e.g. Campus Gate',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field(
                      label: 'TO',
                      controller: _toCtrl,
                      hint: 'e.g. City Center',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Date / Time row
              Row(
                children: [
                  Expanded(
                    child: _field(
                      label: 'DATE',
                      controller: _dateCtrl,
                      hint: 'Today',
                      readOnly: true,
                      onTap: _pickDate,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field(
                      label: 'TIME',
                      controller: _timeCtrl,
                      hint: '08:00 AM',
                      readOnly: true,
                      onTap: _pickTime,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Seats + ETA row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('SEATS'),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _SeatsButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (_seats > 1) setState(() => _seats--);
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                '$_seats',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            _SeatsButton(
                              icon: Icons.add,
                              onTap: () {
                                if (_seats < 8) setState(() => _seats++);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field(
                      label: 'ETA (minutes)',
                      controller: _etaCtrl,
                      hint: '30',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Time slot
              _label('TIME SLOT'),
              const SizedBox(height: 8),
              Row(
                children: _slots
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _SlotChip(
                            label: s.$2,
                            selected: _slot == s.$1,
                            onTap: () => setState(() => _slot = s.$1),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Submit
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Post Ride',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
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
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: AppColors.textLabel,
        ),
      );

  Widget _field({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: AppColors.textHint, fontFamily: 'Inter'),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppColors.error, width: 1.5),
              ),
            ),
          ),
        ],
      );
}

class _SeatsButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SeatsButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.pageBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      );
}

class _SlotChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SlotChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.inputBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      );
}
