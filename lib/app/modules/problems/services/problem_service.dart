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
}
