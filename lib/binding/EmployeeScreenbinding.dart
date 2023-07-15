import 'package:get/get.dart';
import '../Controller/EmployeeController.dart';

class EmployeeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeController());
  }
}
