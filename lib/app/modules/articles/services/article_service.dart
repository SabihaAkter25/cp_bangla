import 'package:get/get.dart';
import '../../../services/supabase_service.dart';
import '../../../data/models/article_model.dart';

class ArticleService extends GetxService {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  Future<List<Article>> getArticles({bool? onlyPublished}) async {
    var query = _supabaseService.client
        .from('articles')
        .select();
    
    if (onlyPublished == true) {
      query = query.eq('published', true);
    }
    
    final response = await query.order('created_at', ascending: false);
    
    return (response as List).map((e) => Article.fromJson(e)).toList();
  }

  Future<void> createArticle(Map<String, dynamic> articleData) async {
    await _supabaseService.client.from('articles').insert(articleData);
  }

  Future<void> updateArticle(String id, Map<String, dynamic> articleData) async {
    await _supabaseService.client
        .from('articles')
        .update(articleData)
        .eq('id', id);
  }

  Future<void> deleteArticle(String id) async {
    await _supabaseService.client.from('articles').delete().eq('id', id);
  }

  // Bookmarks
  Future<void> toggleBookmark(String articleId) async {
    final userId = _supabaseService.currentUser?.id;
    if (userId == null) return;

    final existing = await _supabaseService.client
        .from('bookmarks')
        .select()
        .eq('user_id', userId)
        .eq('article_id', articleId)
        .maybeSingle();

    if (existing != null) {
      await _supabaseService.client
          .from('bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('article_id', articleId);
    } else {
      await _supabaseService.client
          .from('bookmarks')
          .insert({'user_id': userId, 'article_id': articleId});
    }
  }

  Future<List<Article>> getBookmarkedArticles() async {
    final userId = _supabaseService.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabaseService.client
        .from('bookmarks')
        .select('articles!inner(*)')
        .eq('user_id', userId);

    return (response as List).map((e) => Article.fromJson(e['articles'])).toList();
  }

  // Reading History
  Future<void> addToHistory(String articleId) async {
    final userId = _supabaseService.currentUser?.id;
    if (userId == null) return;

    await _supabaseService.client.from('reading_history').upsert({
      'user_id': userId,
      'article_id': articleId,
      'last_read_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Article>> getReadingHistory() async {
    final userId = _supabaseService.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabaseService.client
        .from('reading_history')
        .select('articles!inner(*)')
        .eq('user_id', userId)
        .order('last_read_at', ascending: false);

    return (response as List).map((e) => Article.fromJson(e['articles'])).toList();
  }
}
