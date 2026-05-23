import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/admin_controller.dart';
import '../../../routes/app_pages.dart';

class AdminView extends GetView<AdminController> {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1E1E2C),
                const Color(0xFFBB86FC).withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            tooltip: 'User Dashboard',
            onPressed: () => Get.toNamed(Routes.DASHBOARD),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().signOut(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('Articles', controller.totalArticles.value, Icons.article, () => Get.toNamed(Routes.MANAGE_ARTICLES)),
              _buildStatCard('Problems', controller.totalProblems.value, Icons.code, () => Get.toNamed(Routes.MANAGE_PROBLEMS)),
              _buildStatCard('Topics', controller.totalTopics.value, Icons.topic, () => Get.toNamed(Routes.MANAGE_TOPICS)),
              _buildStatCard('Users', controller.totalUsers.value, Icons.people, () {}),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Get.theme.primaryColor),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(count.toString(), style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
