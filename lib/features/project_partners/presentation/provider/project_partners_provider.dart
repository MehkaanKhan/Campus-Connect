import 'package:flutter/foundation.dart';
import '../../domain/entities/project_partner_entity.dart';
import '../../domain/usecases/get_project_partners_usecase.dart';

class ProjectPartnersProvider extends ChangeNotifier {
  final GetProjectPartnersUsecase getProjectsUsecase;
  final GetFilterChipsUsecase getFilterChipsUsecase;

  ProjectPartnersProvider({
    required this.getProjectsUsecase,
    required this.getFilterChipsUsecase,
  });

  late final List<String> filterChips = getFilterChipsUsecase();
  late final List<ProjectPartnerEntity> allProjects = getProjectsUsecase();

  String _selectedFilter = 'All Roles';
  String get selectedFilter => _selectedFilter;

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  List<ProjectPartnerEntity> get filteredProjects {
    if (_selectedFilter == 'All Roles') return allProjects;
    return allProjects
        .where((p) =>
            p.skills.any((s) => s.toLowerCase().contains(_selectedFilter.toLowerCase())))
        .toList();
  }
}
