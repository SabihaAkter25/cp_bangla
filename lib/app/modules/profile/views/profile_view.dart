import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final user = controller.rxUser.value;
        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('You are not logged in', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.AUTH),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              // Header/Cover
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFBB86FC), Color(0xFF6200EE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[800],
                        child: Text(
                          user.email?.substring(0, 1).toUpperCase() ?? 'U',
                          style: const TextStyle(fontSize: 40, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Text(
                user.email ?? 'User',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(() => controller.isAdmin.value
                  ? Chip(
                      label: const Text('ADMIN'),
                      backgroundColor: Colors.orange.withOpacity(0.2),
                      side: const BorderSide(color: Colors.orange),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 24),

              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatCard('Solved', '0', Icons.check_circle_outline),
                    const SizedBox(width: 16),
                    _buildStatCard('Articles', '0', Icons.article_outlined),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildActionTile(
                      'Admin Panel',
                      Icons.admin_panel_settings,
                      Colors.orange,
                      () => Get.toNamed(Routes.ADMIN),
                      visible: controller.isAdmin.value,
                    ),
                    _buildActionTile(
                      'Settings',
                      Icons.settings_outlined,
                      Colors.blue,
                      () {},
                    ),
                    _buildActionTile(
                      'Help & Support',
                      Icons.help_outline,
                      Colors.green,
                      () {},
                    ),
                    _buildActionTile(
                      'Logout',
                      Icons.logout,
                      Colors.red,
                      controller.signOut,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFFBB86FC)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, Color color, VoidCallback onTap, {bool visible = true}) {
    if (!visible) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
