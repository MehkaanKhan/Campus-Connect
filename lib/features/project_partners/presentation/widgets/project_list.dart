import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/project_partners_provider.dart';
import 'project_card.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectPartnersProvider>().filteredProjects;
    return Column(
      children: projects
          .map((p) => Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: ProjectCard(project: p),
              ))
          .toList(),
    );
  }
}
