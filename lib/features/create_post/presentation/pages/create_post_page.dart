import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/create_post_provider.dart';
import '../widgets/create_post_header.dart';
import '../widgets/create_post_input_card.dart';
import '../widgets/create_post_bottom_toolbar.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // Reset the provider when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CreatePostProvider>().reset();
      }
    });

    _controller.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    context.read<CreatePostProvider>().setContent(_controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onContentChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.borderLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CreatePostHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: CreatePostInputCard(controller: _controller),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
            const CreatePostBottomToolbar(),
          ],
        ),
      ),
    );
  }
}
