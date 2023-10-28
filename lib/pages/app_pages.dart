import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:pesa_makanam_app/Controller/AdminAccessController.dart';
import 'package:pesa_makanam_app/View/Home/drawer/AdminAccess.dart';
import 'package:pesa_makanam_app/View/Login/loginscreen.dart';
import 'package:pesa_makanam_app/binding/AdminAccessbinding.dart';
import '../View/Home/drawer/Adjustment.dart';
import '../View/Home/drawer/Attendance.dart';
import '../View/Home/Home_screen.dart';
import '../View/Home/drawer/AddItems.dart';
import '../View/Home/drawer/Employee.dart';
import '../View/Home/drawer/POS/TicketList.dart';
import '../View/Home/drawer/POS/pos.dart';
import '../View/Home/drawer/Payment.dart';
import '../View/Home/drawer/Purchase/AddPurchase.dart';
import '../View/Home/drawer/Categories.dart';
import '../View/Home/drawer/Purchase/purchase.dart';
import '../View/Login/registerscreen.dart';
import '../View/splashscreen.dart';
import '../binding/AddItemScreenbinding.dart';
import '../binding/AddPurchasescreeninding.dart';
import '../binding/Adjustmentbinding.dart';
import '../binding/AttendanceScreenbinding.dart';
import '../binding/EmployeeScreenbinding.dart';
import '../binding/Homescreenbinding.dart';
import '../binding/Paymentbinding.dart';
import '../binding/PosScreenbinding.dart';
import '../binding/Purchasebinding.dart';
import '../binding/categoriesscreenbinding.dart';
import '../utils/constant.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: ROUTE_SPLASH, page: () => const SplashScreen()),
    GetPage(name: ROUTE_LOGIN, page: () => const loginscreen()),
    GetPage(name: ROUTE_REGISTER, page: () => const Registerscreen()),
    GetPage(
        name: ROUTE_HOME,
        page: () => const HomeScreen(),
        binding: HomeScreenBinding()),
    GetPage(
        name: ROUTE_CATEGORIES,
        page: () => const Categories(),
        binding: CategoriesScreenBinding()),
    GetPage(
        name: ROUTE_ADDITEMS,
        page: () => const AddItems(),
        binding: AddItemsBinding()),
    GetPage(
        name: ROUTE_ADDPURCHASE,
        page: () => const AddPurchase(),
        binding: AddPurchaseScreenBinding()),
    GetPage(
        name: ROUTE_PURCHASE,
        page: () => const Purchase(),
        binding: PurchaseBinding()),
    GetPage(
      name: ROUTE_EMPLOYEE,
      page: () => const Employee(),
      binding: EmployeeScreenBinding(),
    ),
    GetPage(
        name: ROUTE_ATTENDANCE,
        page: () => const Attendance(),
        binding: AttendanceScreenBinding()),
    GetPage(
        name: ROUTE_PAYMENT,
        page: () => const PaymentScreen(),
        binding: PaymentBinding()),
    GetPage(
        name: ROUTE_POS, page: () => const Pos_screen(), binding: PosBinding()),
    GetPage(name: ROUTE_TICKETLIST, page: () => const TicketList()),
    GetPage(
        name: ROUTE_ADJUSTMENT,
        page: () => const Adjustment_Screen(),
        binding: AdjustmentBinding()),
    GetPage(
        name: ROUTE_ADMINACCESS,
        page: () => const AdminAccessScreen(),
        binding: AdminAccessBinding())
  ];
}
