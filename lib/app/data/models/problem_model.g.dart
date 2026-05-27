// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Problem _$ProblemFromJson(Map<String, dynamic> json) => Problem(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      statement: json['statement'] as String?,
      difficulty: json['difficulty'] as String,
      rating: (json['rating'] as num).toInt(),
      topicId: json['topic_id'] as String?,
      correctAnswer: json['correct_answer'] as String?,
    );

Map<String, dynamic> _$ProblemToJson(Problem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'statement': instance.statement,
      'difficulty': instance.difficulty,
      'rating': instance.rating,
      'topic_id': instance.topicId,
      'correct_answer': instance.correctAnswer,
    };
