import 'package:get/get.dart';

import '../Controller/AddItemController.dart';
class AddItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddItemsController()
    );
  }
}
