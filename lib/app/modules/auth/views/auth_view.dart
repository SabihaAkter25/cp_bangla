import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect if already logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.isLoggedIn) {
        controller.redirectBasedOnRole();
      }
    });

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login / Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => controller.signIn(
                          emailController.text,
                          passwordController.text,
                        ),
                        child: const Text('Login'),
                      ),
                      TextButton(
                        onPressed: () => controller.signUp(
                          emailController.text,
                          passwordController.text,
                        ),
                        child: const Text('Register'),
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }
}
