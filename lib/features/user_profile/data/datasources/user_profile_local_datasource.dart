import '../../domain/entities/user_profile_entity.dart';

abstract class UserProfileLocalDataSource {
  Future<UserProfileEntity> getProfile(String userId);
}

class UserProfileLocalDataSourceImpl implements UserProfileLocalDataSource {
  @override
  Future<UserProfileEntity> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const UserProfileEntity(
      id: '1',
      name: 'Mehkaan Khan',
      department: 'Computer Science',
      year: 'Junior',
      bio: '"Building the future of campus tech. Coffee enthusiast."',
      postCount: 12,
      karma: 450,
      ridesCount: 8,
      posts: [
        ProfilePostEntity(
          id: 'p1',
          flair: 'DISCUSSION',
          flairColor: '#D6D6EA',
          title: 'Thoughts on the new library hours?',
          excerpt: 'I noticed they extended the hours for finals week, but honestly, starting at 6 AM seems extreme.',
          upvotes: 42,
          commentCount: 15,
          timeAgo: '2 days ago',
        ),
        ProfilePostEntity(
          id: 'p2',
          flair: 'PROJECT HELP',
          flairColor: '#FED9B8',
          title: 'Looking for a frontend dev for Hackathon',
          excerpt: 'We have a solid backend team (Python/Django) but we need someone with React experience.',
          upvotes: 89,
          commentCount: 24,
          timeAgo: '1 week ago',
        ),
        ProfilePostEntity(
          id: 'p3',
          flair: 'RESOURCE',
          flairColor: '#E2E3E0',
          title: 'Compiled notes for CS301 Midterm',
          excerpt: 'I put together a study guide covering chapters 1–5. Includes practice problems.',
          upvotes: 156,
          commentCount: 32,
          timeAgo: '2 weeks ago',
        ),
      ],
      reactedPosts: [],
      joinedCarpools: ['Carpool to City Center', 'Airport run — Dec 20'],
    );
  }
}
