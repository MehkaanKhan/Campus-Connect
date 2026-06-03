import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/profile_setup_entity.dart';
import '../../domain/entities/university_entity.dart';
import '../../domain/usecases/get_universities_usecase.dart';
import '../../domain/usecases/get_departments_usecase.dart';
import '../../domain/usecases/get_semesters_usecase.dart';
import '../../domain/usecases/save_profile_usecase.dart';

enum ProfileSetupStatus { idle, loading, success, error }

class ProfileSetupProvider extends ChangeNotifier {
  final GetUniversitiesUsecase getUniversitiesUsecase;
  final GetDepartmentsUsecase getDepartmentsUsecase;
  final GetSemestersUsecase getSemestersUsecase;
  final SaveProfileUsecase saveProfileUsecase;

  ProfileSetupProvider({
    required this.getUniversitiesUsecase,
    required this.getDepartmentsUsecase,
    required this.getSemestersUsecase,
    required this.saveProfileUsecase,
  }) {
    _init();
  }

  // ── State ──
  ProfileSetupStatus _status = ProfileSetupStatus.idle;
  ProfileSetupStatus get status => _status;

  String _fullName = '';
  String get fullName => _fullName;

  UniversityEntity? _selectedUniversity;
  UniversityEntity? get selectedUniversity => _selectedUniversity;

  String? _selectedDepartment;
  String? get selectedDepartment => _selectedDepartment;

  String? _selectedSemester;
  String? get selectedSemester => _selectedSemester;

  Uint8List? _photoBytes;
  Uint8List? get photoBytes => _photoBytes;

  List<UniversityEntity> universities = [];
  List<String> departments = [];
  List<String> semesters   = [];

  Future<void> _init() async {
    _status = ProfileSetupStatus.loading;
    notifyListeners();
    try {
      universities = await getUniversitiesUsecase();
      departments = await getDepartmentsUsecase();
      semesters = await getSemestersUsecase();
      _status = ProfileSetupStatus.success;
    } catch (_) {
      _status = ProfileSetupStatus.error;
    }
    notifyListeners();
  }

  // ── Setters ──
  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setUniversity(UniversityEntity? value) {
    _selectedUniversity = value;
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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photoBytes = await pickedFile.readAsBytes();
      notifyListeners();
    }
  }

  bool get isFormValid =>
      _fullName.trim().isNotEmpty &&
      _selectedUniversity != null &&
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
          universityId: _selectedUniversity!.id,
          department: _selectedDepartment!,
          semester: _selectedSemester!,
          photoBytes: _photoBytes,
        ),
      );
      _status = ProfileSetupStatus.success;
    } catch (_) {
      _status = ProfileSetupStatus.error;
    }
    notifyListeners();
  }
}
