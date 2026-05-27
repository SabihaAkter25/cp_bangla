import 'package:json_annotation/json_annotation.dart';

part 'submission_model.g.dart';

@JsonSerializable()
class Submission {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'problem_id')
  final String problemId;
  final String answer;
  @JsonKey(name: 'is_correct')
  final bool isCorrect;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Submission({
    required this.id,
    required this.userId,
    required this.problemId,
    required this.answer,
    required this.isCorrect,
    required this.createdAt,
  });

  factory Submission.fromJson(Map<String, dynamic> json) => _$SubmissionFromJson(json);
  Map<String, dynamic> toJson() => _$SubmissionToJson(this);
}
