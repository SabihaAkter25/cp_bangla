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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF13141C), Color(0xFF1E1E2C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBB86FC).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.code, size: 80, color: Color(0xFFBB86FC)),
                ),
                const SizedBox(height: 24),
                const Text(
                  'CP BANGLA',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Learn competitive programming',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 48),

                // Fields
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 32),

                // Buttons
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : Column(

                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => controller.signIn(
                                emailController.text,
                                passwordController.text,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBB86FC),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => controller.signUp(
                              emailController.text,
                              passwordController.text,
                            ),
                            child: const Text(
                              'Don\'t have an account? Register',
                              style: TextStyle(color: Color(0xFFBB86FC)),
                            ),
                          ),
                        ],
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
