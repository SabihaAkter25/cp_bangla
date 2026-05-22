import 'package:get/get.dart';
import '../services/article_service.dart';
import '../../../data/models/article_model.dart';

class ArticleController extends GetxController {
  final ArticleService _articleService = Get.find<ArticleService>();

  final articles = <Article>[].obs;
  final filteredArticles = <Article>[].obs;
  final bookmarkedArticles = <Article>[].obs;
  final readingHistory = <Article>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedTopicId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
    fetchBookmarks();
    fetchHistory();

    // Setup listeners
    debounce(searchQuery, (_) => _filterArticles(), time: const Duration(milliseconds: 500));
    ever(selectedTopicId, (_) => _filterArticles());
  }

  void searchArticles(String query) {
    searchQuery.value = query;
  }

  void filterByTopic(String? topicId) {
    selectedTopicId.value = topicId ?? '';
  }

  void _filterArticles() {
    var result = articles.toList();

    if (searchQuery.isNotEmpty) {
      result = result.where((article) =>
          article.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          (article.excerpt?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false)).toList();
    }

    if (selectedTopicId.isNotEmpty) {
      result = result.where((article) => article.topicId == selectedTopicId.value).toList();
    }

    filteredArticles.assignAll(result);
  }

  Future<void> fetchArticles({bool onlyPublished = true}) async {
    try {
      isLoading.value = true;
      final fetched = await _articleService.getArticles(onlyPublished: onlyPublished);
      articles.assignAll(fetched);
      _filterArticles();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAdminArticles() => fetchArticles(onlyPublished: false);

  Future<void> createArticle(String title, String slug, String excerpt, String content, String topicId) async {
    try {
      isLoading.value = true;
      await _articleService.createArticle({
        'title': title,
        'slug': slug,
        'excerpt': excerpt,
        'content': content,
        'topic_id': topicId,
        'published': true,
      });
      await fetchAdminArticles();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateArticle(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      await _articleService.updateArticle(id, data);
      await fetchAdminArticles();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> togglePublish(String id, bool currentState) async {
    try {
      await _articleService.updateArticle(id, {'published': !currentState});
      await fetchAdminArticles();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteArticle(String id) async {
    try {
      await _articleService.deleteArticle(id);
      articles.removeWhere((element) => element.id == id);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Bookmarks
  Future<void> fetchBookmarks() async {
    try {
      bookmarkedArticles.assignAll(await _articleService.getBookmarkedArticles());
    } catch (e) {
      print('Error fetching bookmarks: $e');
    }
  }

  Future<void> toggleBookmark(String articleId) async {
    try {
      await _articleService.toggleBookmark(articleId);
      await fetchBookmarks();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  bool isBookmarked(String articleId) {
    return bookmarkedArticles.any((a) => a.id == articleId);
  }

  // History
  Future<void> fetchHistory() async {
    try {
      readingHistory.assignAll(await _articleService.getReadingHistory());
    } catch (e) {
      print('Error fetching history: $e');
    }
  }

  Future<void> addToHistory(String articleId) async {
    try {
      await _articleService.addToHistory(articleId);
      await fetchHistory();
    } catch (e) {
      print('Error adding to history: $e');
    }
  }
}
