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
      appBar: AppBar(
        title: const Text('CP Bangla'),
        centerTitle: true,
      ),
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              ArticleListView(),
              ProblemListView(),
              TopicListView(),
              ProfileView(),
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            type: BottomNavigationBarType.fixed,
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
                icon: Icon(Icons.topic_outlined),
                activeIcon: Icon(Icons.topic),
                label: 'Topics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          )),
    );
  }
}
