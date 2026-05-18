import 'package:flutter/material.dart';
import '../../../../core/utils/size_config.dart';
import '../widgets/profile_setup_card.dart';

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
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 80.h,
                ),
                child: const Center(
                  child: ProfileSetupCard(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
