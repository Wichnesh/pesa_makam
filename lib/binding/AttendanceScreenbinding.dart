import '../Controller/AttendanceController.dart';
import 'package:get/get.dart';

class AttendanceScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AttendanceController());
  }
}