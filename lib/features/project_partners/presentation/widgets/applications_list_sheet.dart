import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/project_application_entity.dart';
import '../provider/project_partners_provider.dart';

class ApplicationsListSheet extends StatefulWidget {
  final String listingId;
  final String projectTitle;

  const ApplicationsListSheet({
    super.key,
    required this.listingId,
    required this.projectTitle,
  });

  @override
  State<ApplicationsListSheet> createState() => _ApplicationsListSheetState();
}

class _ApplicationsListSheetState extends State<ApplicationsListSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectPartnersProvider>().loadApplications(widget.listingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectPartnersProvider>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.pageBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.only(
        top: 20.h,
        bottom: MediaQuery.of(context).padding.bottom + 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Applications',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.projectTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textCaption,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => context.pop(),
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          const Divider(height: 1, color: AppColors.border),
          if (provider.isLoadingApplications)
            const Padding(
              padding: EdgeInsets.all(40.w),
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            )
          else if (provider.currentApplications.isEmpty)
            Padding(
              padding: EdgeInsets.all(40.w),
              child: Center(
                child: Text(
                  'No applications yet.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 15.sp),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                itemCount: provider.currentApplications.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (ctx, i) => _ApplicationItem(app: provider.currentApplications[i]),
              ),
            ),
        ],
      ),
    );
  }
}

class _ApplicationItem extends StatelessWidget {
  final ProjectApplicationEntity app;
  const _ApplicationItem({required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.postAvatarBg,
                backgroundImage: app.applicantAvatarUrl != null ? NetworkImage(app.applicantAvatarUrl!) : null,
                child: app.applicantAvatarUrl == null ? Icon(Icons.person, color: AppColors.white54, size: 20.w) : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.applicantName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: AppColors.textPrimary),
                    ),
                    Text(
                      app.appliedAgo,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(app.status),
            ],
          ),
          SizedBox(height: 12.h),
          if (app.phoneNumber != null && app.phoneNumber!.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.phone, size: 14.w, color: AppColors.textSecondary),
                SizedBox(width: 6.w),
                Text(
                  app.phoneNumber!,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],
          Text(
            app.coverMessage,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textCaption, height: 1.4),
          ),
          if (app.isPending) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    onPressed: () => context.read<ProjectPartnersProvider>().updateApplicationStatus(app.listingId, app.id, 'rejected'),
                    child: const Text('Reject'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    onPressed: () => context.read<ProjectPartnersProvider>().updateApplicationStatus(app.listingId, app.id, 'accepted'),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg, text;
    if (status == 'accepted') {
      bg = AppColors.sageLight;
      text = AppColors.sage;
    } else if (status == 'rejected') {
      bg = AppColors.error.withValues(alpha: 0.1);
      text = AppColors.error;
    } else {
      bg = AppColors.borderLight;
      text = AppColors.textSecondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(100.r)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: text),
      ),
    );
  }
}
