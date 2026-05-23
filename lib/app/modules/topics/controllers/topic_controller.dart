import 'package:get/get.dart';
import '../services/topic_service.dart';
import '../../../data/models/topic_model.dart';

class TopicController extends GetxController {
  final TopicService _topicService = Get.find<TopicService>();

  final topics = <Topic>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    try {
      isLoading.value = true;
      topics.assignAll(await _topicService.getTopics());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTopic(String name, String slug, String description) async {
    try {
      isLoading.value = true;
      await _topicService.createTopic({
        'name': name,
        'slug': slug,
        'description': description,
      });
      await fetchTopics();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTopic(String id) async {
    try {
      await _topicService.deleteTopic(id);
      topics.removeWhere((element) => element.id == id);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
