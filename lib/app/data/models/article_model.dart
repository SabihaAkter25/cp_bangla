import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

@JsonSerializable()
class Article {
  final String id;
  final String title;
  final String slug;
  final String? excerpt;
  final String content;
  @JsonKey(name: 'topic_id')
  final String? topicId;
  @JsonKey(name: 'author_id')
  final String? authorId;
  final bool published;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    required this.slug,
    this.excerpt,
    required this.content,
    this.topicId,
    this.authorId,
    required this.published,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
