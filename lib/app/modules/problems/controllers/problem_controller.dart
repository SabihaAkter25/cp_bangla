import 'package:get/get.dart';
import '../services/problem_service.dart';
import '../../../data/models/problem_model.dart';

class ProblemController extends GetxController {
  final ProblemService _problemService = Get.find<ProblemService>();

  final problems = <Problem>[].obs;
  final filteredProblems = <Problem>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedTopicId = ''.obs;
  final selectedDifficulty = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProblems();

    // Setup listeners
    debounce(searchQuery, (_) => _filterProblems(), time: const Duration(milliseconds: 500));
    ever(selectedTopicId, (_) => _filterProblems());
    ever(selectedDifficulty, (_) => _filterProblems());
  }

  void searchProblems(String query) {
    searchQuery.value = query;
  }

  void filterByTopic(String? topicId) {
    selectedTopicId.value = topicId ?? '';
  }

  void filterByDifficulty(String? difficulty) {
    selectedDifficulty.value = difficulty ?? '';
  }

  void _filterProblems() {
    var result = problems.toList();

    if (searchQuery.isNotEmpty) {
      result = result.where((problem) =>
          problem.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          (problem.statement?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false)).toList();
    }

    if (selectedTopicId.isNotEmpty) {
      result = result.where((problem) => problem.topicId == selectedTopicId.value).toList();
    }

    if (selectedDifficulty.isNotEmpty) {
      result = result.where((problem) => problem.difficulty == selectedDifficulty.value).toList();
    }

    filteredProblems.assignAll(result);
  }

  Future<void> fetchProblems() async {
    try {
      isLoading.value = true;
      final fetched = await _problemService.getProblems();
      problems.assignAll(fetched);
      _filterProblems();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createProblem(String title, String slug, String statement, String difficulty, int rating, String topicId) async {
    try {
      isLoading.value = true;
      await _problemService.createProblem({
        'title': title,
        'slug': slug,
        'statement': statement,
        'difficulty': difficulty,
        'rating': rating,
        'topic_id': topicId,
      });
      await fetchProblems();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProblem(String id) async {
    try {
      await _problemService.deleteProblem(id);
      problems.removeWhere((element) => element.id == id);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
