import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';

abstract class FeedLocalDataSource {
  Future<List<PostEntity>> getPosts();
}

class FeedLocalDataSourceImpl implements FeedLocalDataSource {
  @override
  Future<List<PostEntity>> getPosts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      PostEntity(
        id: '1',
        authorName: 'Sarah J.',
        timeAgo: '2 HOURS AGO',
        flair: 'Events',
        flairColor: const Color(0xFFD6D6EA),
        title: "Who's coming to the hackathon tonight?",
        excerpt: "Need a team for the AI track! We have a solid backend already.",
        upvotes: 42,
        downvotes: 3,
        commentCount: 12,
      ),
      PostEntity(
        id: '2',
        authorName: 'Prof. Miller',
        timeAgo: '5 HOURS AGO',
        flair: 'Academic',
        flairColor: const Color(0xFFFED9B8),
        title: 'New research lab opening soon!',
        excerpt:
            'We are looking for undergraduate research assistants for the upcoming semester. Check the department board for details.',
        imageUrl: 'assets/images/placeholder.png',
        upvotes: 128,
        downvotes: 2,
        commentCount: 34,
      ),
      PostEntity(
        id: '3',
        authorName: 'Campus Events',
        timeAgo: '1 DAY AGO',
        flair: 'Hostel',
        flairColor: const Color(0xFFE2E3E0),
        title: 'Inter-hostel cricket tournament this weekend',
        excerpt:
            'Sign your hostel team up before Thursday. Trophies and prizes for top 3 teams.',
        upvotes: 89,
        downvotes: 1,
        commentCount: 27,
      ),
      PostEntity(
        id: '4',
        authorName: 'Ali K.',
        timeAgo: '2 DAYS AGO',
        flair: 'Carpool',
        flairColor: const Color(0xFFE2E9E0),
        title: 'Carpool to City Center — Friday 5 PM',
        excerpt:
            '3 seats available. Sharing fuel costs. DM me if interested.',
        upvotes: 31,
        downvotes: 0,
        commentCount: 8,
      ),
      PostEntity(
        id: '5',
        authorName: 'Zara M.',
        timeAgo: '3 DAYS AGO',
        flair: 'Marketplace',
        flairColor: const Color(0xFFD6D6EA),
        title: 'Selling Calculus textbook — great condition',
        excerpt:
            'Thomas\' Calculus 14th edition. Used for one semester. Asking Rs. 800.',
        upvotes: 15,
        downvotes: 0,
        commentCount: 5,
      ),
    ];
  }
}
