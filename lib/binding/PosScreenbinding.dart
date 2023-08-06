import '../Controller/PosController.dart';
import 'package:get/get.dart';

class PosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PosController());
  }
}
