import 'package:get/get.dart';

import '../modules/admin/bindings/admin_binding.dart';
import '../modules/admin/views/admin_view.dart';
import '../modules/articles/views/article_detail_view.dart';
import '../modules/admin/views/manage_articles_view.dart';
import '../modules/admin/views/manage_problems_view.dart';
import '../modules/admin/views/manage_topics_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
    ),
    GetPage(
      name: _Paths.ADMIN,
      page: () => const AdminView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLE_DETAILS,
      page: () => const ArticleDetailView(),
    ),
    GetPage(
      name: _Paths.MANAGE_ARTICLES,
      page: () => const ManageArticlesView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_PROBLEMS,
      page: () => const ManageProblemsView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_TOPICS,
      page: () => const ManageTopicsView(),
      binding: AdminBinding(),
    ),
  ];
}
