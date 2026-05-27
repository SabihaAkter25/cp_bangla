// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Submission _$SubmissionFromJson(Map<String, dynamic> json) => Submission(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      problemId: json['problem_id'] as String,
      answer: json['answer'] as String,
      isCorrect: json['is_correct'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SubmissionToJson(Submission instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'problem_id': instance.problemId,
      'answer': instance.answer,
      'is_correct': instance.isCorrect,
      'created_at': instance.createdAt.toIso8601String(),
    };
