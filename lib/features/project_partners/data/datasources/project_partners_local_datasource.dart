import '../../domain/entities/project_partner_entity.dart';

class ProjectPartnersLocalDataSource {
  List<ProjectPartnerEntity> getProjects() => const [
        ProjectPartnerEntity(
          id: '1',
          creatorId: 'mock_user',
          badge: 'ACADEMIC PROJECT',
          badgeColor: '#6B8F6B',
          title: 'Campus Sustainable Transit App',
          description:
              'We are building an iOS app to gamify and track sustainable transit options around campus. Need technical folks to help with backend architecture and mapping APIs.',
          skills: ['Swift / iOS', 'Node.js', 'Google Maps API'],
        ),
        ProjectPartnerEntity(
          id: '2',
          creatorId: 'mock_user',
          badge: 'STARTUP IDEA',
          badgeColor: '#C8913A',
          title: 'Dorm Room Chef Platform',
          description:
              'A marketplace connecting students who love to cook with those looking for homemade meals. Looking for a co-founder with a design eye.',
          skills: ['Figma', 'User Research'],
        ),
        ProjectPartnerEntity(
          id: '3',
          creatorId: 'mock_user',
          badge: 'HACKATHON',
          badgeColor: '#5A7FA8',
          title: 'AI Study Assistant Bot',
          description:
              'Gearing up for the Spring Hackathon. Building a Discord bot that summarizes lecture notes using LLMs.',
          skills: ['Python', 'Prompt Engineering'],
        ),
      ];

  List<String> getFilterChips() => const [
        'All Roles',
        'Computer Science',
        'UI/UX Design',
        'Business',
        'Engineering',
      ];
}
