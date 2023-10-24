import 'package:get/get.dart';
import '../Controller/Paymentcontroller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentController());
  }
}
