import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../articles/views/article_list_view.dart';
import '../../problems/views/problem_list_view.dart';
import '../../profile/views/profile_view.dart';
import '../../topics/views/topic_list_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => SafeArea(
            child: IndexedStack(
              index: controller.currentIndex.value,
              children: const [
                ArticleListView(),
                ProblemListView(),
                TopicListView(),
                ProfileView(),
              ],
            ),
          )),
      bottomNavigationBar: Obx(() => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E1E2C),
                  const Color(0xFFBB86FC).withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changePage,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.article_outlined),
                  activeIcon: Icon(Icons.article),
                  label: 'Articles',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.code_outlined),
                  activeIcon: Icon(Icons.code),
                  label: 'Problems',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_outlined),
                  activeIcon: Icon(Icons.grid_view_rounded),
                  label: 'Topics',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          )),
    );
  }
}
