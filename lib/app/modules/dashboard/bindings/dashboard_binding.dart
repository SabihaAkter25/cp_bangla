import 'package:get/get.dart';
import '../../articles/controllers/article_controller.dart';
import '../../articles/services/article_service.dart';
import '../../problems/controllers/problem_controller.dart';
import '../../problems/services/problem_service.dart';
import '../../topics/controllers/topic_controller.dart';
import '../../topics/services/topic_service.dart';
import '../controllers/dashboard_controller.dart';

class  DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    
    // Articles
    Get.lazyPut<ArticleService>(() => ArticleService());
    Get.lazyPut<ArticleController>(() => ArticleController());

    // Problems
    Get.lazyPut<ProblemService>(() => ProblemService());
    Get.lazyPut<ProblemController>(() => ProblemController());

    // Topics
    Get.lazyPut<TopicService>(() => TopicService());
    Get.lazyPut<TopicController>(() => TopicController());
  }
}
