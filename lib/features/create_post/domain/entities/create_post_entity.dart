import 'dart:typed_data';

class CreatePostEntity {
  final String title;
  final String content;
  final Uint8List? imageBytes;
  final List<String> tags;

  const CreatePostEntity({
    required this.title,
    required this.content,
    this.imageBytes,
    this.tags = const [],
  });

  CreatePostEntity copyWith({
    String? title,
    String? content,
    Uint8List? imageBytes,
    List<String>? tags,
  }) =>
      CreatePostEntity(
        title: title ?? this.title,
        content: content ?? this.content,
        imageBytes: imageBytes ?? this.imageBytes,
        tags: tags ?? this.tags,
      );
}
