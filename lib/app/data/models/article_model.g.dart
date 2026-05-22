// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
  id: json['id'] as String,
  title: json['title'] as String,
  slug: json['slug'] as String,
  excerpt: json['excerpt'] as String?,
  content: json['content'] as String,
  topicId: json['topic_id'] as String?,
  authorId: json['author_id'] as String?,
  published: json['published'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'slug': instance.slug,
  'excerpt': instance.excerpt,
  'content': instance.content,
  'topic_id': instance.topicId,
  'author_id': instance.authorId,
  'published': instance.published,
  'created_at': instance.createdAt.toIso8601String(),
};
