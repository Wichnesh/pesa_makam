import 'package:get/get.dart';

import '../Model/Homemodel.dart';
import 'homeController.dart';

class PosController extends GetxController {
  var isloading = false.obs;
  RxList<forPosTicketDetail> detailList = RxList<forPosTicketDetail>();
}
