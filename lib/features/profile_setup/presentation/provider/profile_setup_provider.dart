import 'package:flutter/foundation.dart';
import '../../domain/entities/profile_setup_entity.dart';
import '../../domain/usecases/get_departments_usecase.dart';
import '../../domain/usecases/get_semesters_usecase.dart';
import '../../domain/usecases/save_profile_usecase.dart';

enum ProfileSetupStatus { idle, loading, success, error }

class ProfileSetupProvider extends ChangeNotifier {
  final GetDepartmentsUsecase getDepartmentsUsecase;
  final GetSemestersUsecase getSemestersUsecase;
  final SaveProfileUsecase saveProfileUsecase;

  ProfileSetupProvider({
    required this.getDepartmentsUsecase,
    required this.getSemestersUsecase,
    required this.saveProfileUsecase,
  });

  // ── State ──
  ProfileSetupStatus _status = ProfileSetupStatus.idle;
  ProfileSetupStatus get status => _status;

  String _fullName = '';
  String get fullName => _fullName;

  String? _selectedDepartment;
  String? get selectedDepartment => _selectedDepartment;

  String? _selectedSemester;
  String? get selectedSemester => _selectedSemester;

  String? _photoPath;
  String? get photoPath => _photoPath;

  late final List<String> departments = getDepartmentsUsecase();
  late final List<String> semesters   = getSemestersUsecase();

  // ── Setters ──
  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setDepartment(String? value) {
    _selectedDepartment = value;
    notifyListeners();
  }

  void setSemester(String? value) {
    _selectedSemester = value;
    notifyListeners();
  }

  void setPhotoPath(String? path) {
    _photoPath = path;
    notifyListeners();
  }

  bool get isFormValid =>
      _fullName.trim().isNotEmpty &&
      _selectedDepartment != null &&
      _selectedSemester != null;

  // ── Actions ──
  Future<void> saveProfile() async {
    if (!isFormValid) return;
    _status = ProfileSetupStatus.loading;
    notifyListeners();
    try {
      await saveProfileUsecase(
        ProfileSetupEntity(
          fullName: _fullName.trim(),
          department: _selectedDepartment!,
          semester: _selectedSemester!,
          photoPath: _photoPath,
        ),
      );
      _status = ProfileSetupStatus.success;
    } catch (_) {
      _status = ProfileSetupStatus.error;
    }
    notifyListeners();
  }
}
