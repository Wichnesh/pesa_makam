import '../Controller/Adjustmentcontroller.dart';
import '../Controller/PosController.dart';
import 'package:get/get.dart';

class AdjustmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdjustmentController());
  }
}
