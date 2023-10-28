import '../Controller/AdminAccessController.dart';
import 'package:get/get.dart';

class AdminAccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminAccessController());
  }
}
