import 'package:get/get.dart';
import '../controllers/article_controller.dart';
import '../services/article_service.dart';

class ArticleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleService>(() => ArticleService());
    Get.lazyPut<ArticleController>(() => ArticleController());
  }
}
