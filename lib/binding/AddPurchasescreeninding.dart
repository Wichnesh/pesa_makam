import 'package:get/get.dart';

import '../Controller/AddPurchaseController.dart';

class AddPurchaseScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddPurchaseController());
  }
}
