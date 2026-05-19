import 'package:flutter/foundation.dart';
import '../../domain/entities/project_partner_entity.dart';
import '../../domain/usecases/get_project_partners_usecase.dart';

enum ProjectPartnersStatus { idle, loading, success, error }

class ProjectPartnersProvider extends ChangeNotifier {
  final GetProjectPartnersUsecase getProjectsUsecase;
  final GetFilterChipsUsecase getFilterChipsUsecase;

  ProjectPartnersProvider({
    required this.getProjectsUsecase,
    required this.getFilterChipsUsecase,
  }) {
    _loadData();
  }

  List<String> filterChips = [];
  List<ProjectPartnerEntity> allProjects = [];

  ProjectPartnersStatus _status = ProjectPartnersStatus.idle;
  ProjectPartnersStatus get status => _status;

  String _selectedFilter = 'All Roles';
  String get selectedFilter => _selectedFilter;

  Future<void> _loadData() async {
    _status = ProjectPartnersStatus.loading;
    notifyListeners();

    try {
      final chipsResult = await getFilterChipsUsecase();
      final projectsResult = await getProjectsUsecase();
      
      filterChips = chipsResult;
      allProjects = projectsResult;
      _status = ProjectPartnersStatus.success;
    } catch (e) {
      _status = ProjectPartnersStatus.error;
    }
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  List<ProjectPartnerEntity> get filteredProjects {
    if (_selectedFilter == 'All Roles') return allProjects;
    return allProjects
        .where((p) => p.skills.any((s) => s.toLowerCase().contains(_selectedFilter.toLowerCase())))
        .toList();
  }
}
