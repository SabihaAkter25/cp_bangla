import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';
import '../../../services/supabase_service.dart';

class AuthController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  final Rxn<User> rxUser = Rxn<User>();
  final isAdmin = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Set initial user
    rxUser.value = _supabaseService.client.auth.currentUser;
    if (rxUser.value != null) {
      checkAdminStatus();
    }

    // Listen auth state changes
    _supabaseService.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        rxUser.value = session.user;
        checkAdminStatus();
      } else {
        rxUser.value = null;
        isAdmin.value = false;
      }
    });
  }

  Future<void> checkAdminStatus() async {
    try {
      final userId = rxUser.value?.id;
      if (userId == null) return;

      final response = await _supabaseService.client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();
      
      isAdmin.value = response['role'] == 'admin';
    } catch (e) {
      print('Error checking admin status: $e');
      isAdmin.value = false;
    }
  }

  // =========================
  // SIGN UP
  // =========================
  Future<void> signUp(String email, String password, {String? name}) async {
    try {
      isLoading.value = true;

      final response = await _supabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name ?? 'User',
        },
      );

      if (response.user != null) {
        Get.offAllNamed(Routes.DASHBOARD);
        Get.snackbar("Success", "Account created successfully");
      }
    } on AuthException catch (e) {
      Get.snackbar("Signup Failed", e.message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;

      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await checkAdminStatus();
        if (isAdmin.value) {
          Get.offAllNamed(Routes.ADMIN);
        } else {
          Get.offAllNamed(Routes.DASHBOARD);
        }
        Get.snackbar("Success", "Login successful");
      }
    } on AuthException catch (e) {
      Get.snackbar("Login Failed", e.message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // REDIRECT IF LOGGED IN
  // =========================
  void redirectBasedOnRole() async {
    if (rxUser.value != null) {
      await checkAdminStatus();
      if (isAdmin.value) {
        Get.offAllNamed(Routes.ADMIN);
      } else {
        Get.offAllNamed(Routes.DASHBOARD);
      }
    }
  }

  // =========================
  // SIGN OUT
  // =========================
  Future<void> signOut() async {
    try {
      isLoading.value = true;

      await _supabaseService.client.auth.signOut();

      rxUser.value = null;
      isAdmin.value = false;

      Get.offAllNamed(Routes.AUTH);
      Get.snackbar("Success", "Logged out successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // GET CURRENT USER
  // =========================
  User? get currentUser => rxUser.value;

  bool get isLoggedIn => rxUser.value != null;
}