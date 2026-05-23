import 'package:get/get.dart';
import '../../../services/supabase_service.dart';
import '../../../data/models/topic_model.dart';

class TopicService extends GetxService {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  Future<List<Topic>> getTopics() async {
    final response = await _supabaseService.client
        .from('topics')
        .select()
        .order('name', ascending: true);
    
    return (response as List).map((e) => Topic.fromJson(e)).toList();
  }

  Future<void> createTopic(Map<String, dynamic> topicData) async {
    await _supabaseService.client.from('topics').insert(topicData);
  }

  Future<void> updateTopic(String id, Map<String, dynamic> topicData) async {
    await _supabaseService.client
        .from('topics')
        .update(topicData)
        .eq('id', id);
  }

  Future<void> deleteTopic(String id) async {
    await _supabaseService.client.from('topics').delete().eq('id', id);
  }
}
