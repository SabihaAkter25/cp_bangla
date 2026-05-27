import 'package:json_annotation/json_annotation.dart';

part 'problem_model.g.dart';

@JsonSerializable()
class Problem {
  final String id;
  final String title;
  final String slug;
  final String? statement;
  final String difficulty;
  final int rating;
  @JsonKey(name: 'topic_id')
  final String? topicId;
  @JsonKey(name: 'correct_answer')
  final String? correctAnswer;

  Problem({
    required this.id,
    required this.title,
    required this.slug,
    this.statement,
    required this.difficulty,
    required this.rating,
    this.topicId,
    this.correctAnswer,
  });

  factory Problem.fromJson(Map<String, dynamic> json) => _$ProblemFromJson(json);
  Map<String, dynamic> toJson() => _$ProblemToJson(this);
}
