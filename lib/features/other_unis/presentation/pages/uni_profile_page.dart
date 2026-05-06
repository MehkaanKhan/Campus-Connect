import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../domain/entities/other_uni_entity.dart';

class UniProfilePage extends StatelessWidget {
  final OtherUniEntity uni;

  const UniProfilePage({super.key, required this.uni});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CampusTopNavBar(
          onBack: context.canPop() ? () => context.pop() : null,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Hero(
                    tag: 'uni_logo_${uni.id}',
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        uni.logoText,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    uni.name,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    uni.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        uni.region,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'University Stats',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  DataTable(
                    headingRowHeight: 0, // Hide header
                    columns: const [
                      DataColumn(label: Text('Metric')),
                      DataColumn(label: Text('Value')),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('Total Members', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
                        DataCell(Text('${uni.memberCount}', style: const TextStyle(fontWeight: FontWeight.bold))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Activity Score', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
                        DataCell(Text('${uni.activityScore} / 100', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Active Clubs', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
                        DataCell(Text('${(uni.memberCount * 0.01).toInt()}', style: const TextStyle(fontWeight: FontWeight.bold))),
                      ]),
                      const DataRow(cells: [
                        DataCell(Text('Status', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
                        DataCell(Text('Partner Network', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary))),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
