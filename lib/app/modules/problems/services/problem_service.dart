import 'package:get/get.dart';
import '../../../services/supabase_service.dart';
import '../../../data/models/problem_model.dart';

class ProblemService extends GetxService {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  Future<List<Problem>> getProblems() async {
    final response = await _supabaseService.client
        .from('problems')
        .select()
        .order('rating', ascending: true);
    
    return (response as List).map((e) => Problem.fromJson(e)).toList();
  }

  Future<void> createProblem(Map<String, dynamic> problemData) async {
    await _supabaseService.client.from('problems').insert(problemData);
  }

  Future<void> updateProblem(String id, Map<String, dynamic> problemData) async {
    await _supabaseService.client
        .from('problems')
        .update(problemData)
        .eq('id', id);
  }

  Future<void> deleteProblem(String id) async {
    await _supabaseService.client.from('problems').delete().eq('id', id);
  }

  // Submissions
  Future<bool> submitAnswer(String problemId, String answer, bool isCorrect) async {
    final userId = _supabaseService.currentUser?.id;
    if (userId == null) return false;

    await _supabaseService.client.from('submissions').insert({
      'user_id': userId,
      'problem_id': problemId,
      'answer': answer,
      'is_correct': isCorrect,
    });
    return isCorrect;
  }

  Future<int> getSolvedProblemsCount() async {
    final userId = _supabaseService.currentUser?.id;
    if (userId == null) return 0;

    final response = await _supabaseService.client
        .from('submissions')
        .select('problem_id')
        .eq('user_id', userId)
        .eq('is_correct', true);
    
    // Get unique problem IDs
    final uniqueProblems = (response as List).map((e) => e['problem_id']).toSet();
    return uniqueProblems.length;
  }

  Future<bool> hasSolved(String problemId) async {
    final userId = _supabaseService.currentUser?.id;
    if (userId == null) return false;

    final response = await _supabaseService.client
        .from('submissions')
        .select()
        .eq('user_id', userId)
        .eq('problem_id', problemId)
        .eq('is_correct', true)
        .maybeSingle();

    return response != null;
  }
}
