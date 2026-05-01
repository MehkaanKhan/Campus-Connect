import '../../domain/entities/profile_setup_entity.dart';

abstract class ProfileSetupLocalDataSource {
  List<String> getDepartments();
  List<String> getSemesters();
  Future<void> saveProfile(ProfileSetupEntity profile);
}

class ProfileSetupLocalDataSourceImpl implements ProfileSetupLocalDataSource {
  @override
  List<String> getDepartments() => const [
        'Computer Science',
        'Software Engineering',
        'Electrical Engineering',
        'Mechanical Engineering',
        'Business Administration',
        'Economics',
        'Mathematics',
        'Physics',
        'Chemistry',
        'Biology',
        'Psychology',
        'Media Studies',
      ];

  @override
  List<String> getSemesters() => const [
        'Semester 1',
        'Semester 2',
        'Semester 3',
        'Semester 4',
        'Semester 5',
        'Semester 6',
        'Semester 7',
        'Semester 8',
      ];

  @override
  Future<void> saveProfile(ProfileSetupEntity profile) async {
    // TODO: persist with SharedPreferences / remote API
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
