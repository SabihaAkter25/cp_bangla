import 'package:get/get.dart';
import '../../../services/supabase_service.dart';

class AdminController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  final totalArticles = 0.obs;
  final totalProblems = 0.obs;
  final totalTopics = 0.obs;
  final totalUsers = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      isLoading.value = true;

      // ARTICLES COUNT
      final articlesRes = await _supabaseService.client
          .from('articles')
          .count();

      totalArticles.value = articlesRes;

      // PROBLEMS COUNT
      final problemsRes = await _supabaseService.client
          .from('problems')
          .count();

      totalProblems.value = problemsRes;

      // TOPICS COUNT
      final topicsRes = await _supabaseService.client
          .from('topics')
          .count();

      totalTopics.value = topicsRes;

      // USERS COUNT
      final usersRes = await _supabaseService.client
          .from('profiles')
          .count();

      totalUsers.value = usersRes;

    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch stats: $e');
    } finally {
      isLoading.value = false;
    }
  }
}