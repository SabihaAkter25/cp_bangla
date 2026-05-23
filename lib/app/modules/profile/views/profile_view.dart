import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          final user = controller.rxUser.value;
          if (user == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You are not logged in'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.AUTH),
                  child: const Text('Go to Login'),
                ),
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Logged in as: ${user.email}'),
              const SizedBox(height: 20),
              Obx(() => controller.isAdmin.value
                  ? Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => Get.toNamed(Routes.ADMIN),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Admin Panel'),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  : const SizedBox.shrink()),
              ElevatedButton(
                onPressed: controller.signOut,
                child: const Text('Logout'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
