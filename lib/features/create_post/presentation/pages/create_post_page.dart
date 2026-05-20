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
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<CreatePostProvider>().reset();
    });

    _titleController.addListener(_onTitleChanged);
    _contentController.addListener(_onContentChanged);
  }

  void _onTitleChanged() {
    context.read<CreatePostProvider>().setTitle(_titleController.text);
  }

  void _onContentChanged() {
    context.read<CreatePostProvider>().setContent(_contentController.text);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _contentController.removeListener(_onContentChanged);
    _titleController.dispose();
    _contentController.dispose();
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
                      child: CreatePostInputCard(
                        titleController: _titleController,
                        contentController: _contentController,
                      ),
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
