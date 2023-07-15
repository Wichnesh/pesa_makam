import 'package:get/get.dart';
import '../Controller/categoriescontroller.dart';

class CategoriesScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoriesController());
  }
}
