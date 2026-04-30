class CreatePostEntity {
  final String title;
  final String content;
  final String? imagePath;
  final List<String> tags;

  const CreatePostEntity({
    required this.title,
    required this.content,
    this.imagePath,
    this.tags = const [],
  });

  CreatePostEntity copyWith({
    String? title,
    String? content,
    String? imagePath,
    List<String>? tags,
  }) =>
      CreatePostEntity(
        title: title ?? this.title,
        content: content ?? this.content,
        imagePath: imagePath ?? this.imagePath,
        tags: tags ?? this.tags,
      );
}
