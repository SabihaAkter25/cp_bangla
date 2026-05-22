import 'package:get/get.dart';
import '../../articles/controllers/article_controller.dart';
import '../../articles/services/article_service.dart';
import '../../problems/controllers/problem_controller.dart';
import '../../problems/services/problem_service.dart';
import '../../topics/controllers/topic_controller.dart';
import '../../topics/services/topic_service.dart';
import '../controllers/admin_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(() => AdminController());
    Get.lazyPut<ArticleService>(() => ArticleService());
    Get.lazyPut<ArticleController>(() => ArticleController());
    Get.lazyPut<ProblemService>(() => ProblemService());
    Get.lazyPut<ProblemController>(() => ProblemController());
    Get.lazyPut<TopicService>(() => TopicService());
    Get.lazyPut<TopicController>(() => TopicController());
  }
}
