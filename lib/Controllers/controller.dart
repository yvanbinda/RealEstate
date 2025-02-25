import 'package:get/get.dart';
import 'addProperty_controller.dart';
import 'auth_controller.dart';
import 'profile_controller.dart';

class Controller {
  static void initialize() {
    Get.put(AuthController());
    Get.put(ProfileController());
    Get.put(AddPropertyController());
  }
}