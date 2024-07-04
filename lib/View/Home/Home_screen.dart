import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pesa_makanam_app/Controller/homeController.dart';
import 'package:pesa_makanam_app/Model/BillModel.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import '../../Controller/PosController.dart';
import '../../Model/Homemodel.dart';
import '../../utils/colorUtils.dart';
import '../../utils/common_methods.dart';
import '../../utils/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late SharedPreferences _prefs;

  @override
  void initState() {
    _initializePreferences();
    super.initState();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  final PosController posController = Get.put(PosController());
  final HomeController homecontroller = Get.put(HomeController());
  final int _screen = 0;
  int? selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    double w = MediaQuery.of(context).size.width;
    int columnCount = 4;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) => controller.isloading.value
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                body: LayoutBuilder(builder: (context, constraint) {
                  if (isLandscape) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 4, // 40% of the available space
                          child: Card(
                            elevation: 5,
                            child: Scaffold(
                              appBar: AppBar(
                                title: const Text('Billing'),
                                actions: [
                                  GestureDetector(
                                    onTap: () {
                                      posController.fetchSavedBillData();
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.history,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                            width:
                                                4), // Adjust spacing as needed
                                        Text(
                                          'Billing History',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  )
                                ],
                                backgroundColor: primarycolor,
                              ),
                              body: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Center(
                                      child: Obx(() => posController.tableIds.isEmpty ? Container() : DropdownButton<String>(
                                        value:posController.selectedTable.value,
                                        onChanged: (String? newValue) {
                                          if (kDebugMode) {
                                            print('Selected Table Document ID: $newValue');
                                            posController.selectedTable.value = newValue!;
                                            if(newValue == "Select the Table"){
                                              posController.detailList.clear();
                                              posController.totalamount.value = "0";
                                              Fluttertoast.showToast(msg: "Select the Table");
                                            }else{
                                              posController.fetchTable();
                                            }

                                          }
                                        },
                                        items: posController.tableIds
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      )),
                                    ),
                                    GetBuilder<PosController>(
                                      init: PosController(),
                                      builder: ((controller) =>
                                          Obx(() => controller.isloading.value
                                              ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                              :SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  10.0),
                                              child: Column(
                                                children: [
                                                  const Card(
                                                      child: ListTile(
                                                        title: Text(
                                                          'Dine in',
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                        trailing: Icon(Icons
                                                            .arrow_drop_down_sharp),
                                                      )),

                                                  GetBuilder<PosController>(
                                                    init: PosController(),
                                                    builder: (controller) =>
                                                    controller.isloading
                                                        .value
                                                        ? const Center(
                                                      child:
                                                      CircularProgressIndicator(),
                                                    )
                                                        : _buildDataTable(controller.detailList),
                                                  ),
                                                  GetBuilder<PosController>(
                                                    init: PosController(),
                                                    builder: ((controller) {
                                                      double amount = controller
                                                          .calculateTotalAmount();
                                                      controller.totalamount
                                                          .value =
                                                          amount.toString();
                                                      return Obx(() => Text(
                                                        'Total Amount : ${controller.totalamount.value} RM',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 24),
                                                      ));
                                                    }),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                    screenHeight * 0.05,
                                                  ),
                                                  _buildActionButtons(controller, homecontroller)
                                                ],
                                              ),
                                            ),
                                          )))
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6, // 60% of the available space
                          child: Card(
                            elevation: 5,
                            child: DefaultTabController(
                              length: controller.categories.length,
                              child: Scaffold(
                                appBar: AppBar(
                                  title: const Text('Items'),
                                  backgroundColor: primarycolor,
                                ),
                                body: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: List<Widget>.generate(
                                        controller.categories.length, (index) {
                                      switch (_screen) {
                                        case 0:
                                          if (controller
                                              .istabscreenloading.value) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else {
                                            try {
                                              if (controller.Detail.isEmpty) {
                                                return const Center(
                                                  child: Text('No Data '),
                                                );
                                              } else if (controller
                                                  .Detail.isNotEmpty) {
                                                return AnimationLimiter(
                                                  child: GridView.count(
                                                    physics:
                                                        const BouncingScrollPhysics(
                                                            parent:
                                                                AlwaysScrollableScrollPhysics()),
                                                    padding: EdgeInsets.all(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            60),
                                                    crossAxisCount: MediaQuery
                                                                    .of(context)
                                                                .size
                                                                .shortestSide <
                                                            600
                                                        ? 3
                                                        : 4,
                                                    children: List.generate(
                                                      controller.Detail.length,
                                                      (int index) {
                                                        if (index >=
                                                            controller.Detail
                                                                .length) {
                                                          return const SizedBox(); // Placeholder widget when index is out of range
                                                        }

                                                        final imageSize =
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                4; // Adjust image size based on screen width
                                                        final fontSize = MediaQuery
                                                                    .of(context)
                                                                .size
                                                                .width *
                                                            0.04; // Adjust font size based on screen width
                                                        final itemMargin =
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                30; // Adjust margin based on screen width

                                                        return AnimationConfiguration
                                                            .staggeredGrid(
                                                          position: index,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          columnCount: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .shortestSide <
                                                                  600
                                                              ? 3
                                                              : 4,
                                                          child: ScaleAnimation(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        900),
                                                            curve: Curves
                                                                .fastLinearToSlowEaseIn,
                                                            child:
                                                                FadeInAnimation(
                                                              child: InkWell(
                                                                onLongPress:
                                                                    controller
                                                                            .adminAccess
                                                                            .value
                                                                        ? () {
                                                                            debugPrint("Print Delete  current item name = ${controller.Detail[index].name}, current tab ${controller.categories[selectedTab!]}");
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return DialogBox(
                                                                                  title: "Delete",
                                                                                  content: controller.Detail[index].name,
                                                                                  context: context,
                                                                                  function: () {
                                                                                    controller.deleteSubCollectionItem(controller.categories[selectedTab!], controller.Detail[index].name);
                                                                                    Navigator.of(context).pop(); // Close the dialog after the function is executed
                                                                                  },
                                                                                );
                                                                              },
                                                                            );
                                                                          }
                                                                        : () {
                                                                            debugPrint("Don't have access");
                                                                          },
                                                                onTap: () {
                                                                  controller.addItem(forPosTicketDetail(
                                                                      description: controller
                                                                          .Detail[
                                                                              index]
                                                                          .description,
                                                                      price: controller
                                                                          .Detail[
                                                                              index]
                                                                          .price,
                                                                      image: controller
                                                                          .Detail[
                                                                              index]
                                                                          .image,
                                                                      name: controller
                                                                          .Detail[
                                                                              index]
                                                                          .name));
                                                                  if (kDebugMode) {
                                                                    print(
                                                                        '${controller.Detail[index].name} - ${controller.Detail[index].price}');
                                                                  }
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            20)),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.1),
                                                                        blurRadius:
                                                                            40,
                                                                        spreadRadius:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Image
                                                                            .network(
                                                                          controller
                                                                              .Detail[index]
                                                                              .image,
                                                                          width:
                                                                              imageSize,
                                                                          height:
                                                                              imageSize,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          loadingBuilder: (context,
                                                                              child,
                                                                              loadingProgress) {
                                                                            if (loadingProgress ==
                                                                                null) {
                                                                              return child;
                                                                            }
                                                                            return const Center(
                                                                              child: CircularProgressIndicator(),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10), // Adjust the spacing between image and text
                                                                      Text(
                                                                        controller
                                                                            .Detail[index]
                                                                            .name,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return AnimationLimiter(
                                                    child: GridView.count(
                                                  physics:
                                                      const BouncingScrollPhysics(
                                                          parent:
                                                              AlwaysScrollableScrollPhysics()),
                                                  padding:
                                                      EdgeInsets.all(w / 60),
                                                  crossAxisCount: columnCount,
                                                  children: List.generate(
                                                    controller.Detail.length,
                                                    (int index) {
                                                      if (index >=
                                                          controller
                                                              .Detail.length) {
                                                        return const SizedBox(); // Placeholder widget when index is out of range
                                                      }
                                                      return AnimationConfiguration
                                                          .staggeredGrid(
                                                        position: index,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        columnCount:
                                                            columnCount,
                                                        child: ScaleAnimation(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      900),
                                                          curve: Curves
                                                              .fastLinearToSlowEaseIn,
                                                          child:
                                                              FadeInAnimation(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom: w /
                                                                          30,
                                                                      left: w /
                                                                          60,
                                                                      right: w /
                                                                          60),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            20)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.1),
                                                                    blurRadius:
                                                                        40,
                                                                    spreadRadius:
                                                                        10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ));
                                              }
                                            } catch (e) {
                                              return Center(
                                                child: Text(e.toString()),
                                              );
                                            }
                                          }
                                        default:
                                          return const Text('error');
                                      }
                                    }),
                                  ),
                                ),
                                bottomNavigationBar: AnimatedCrossFade(
                                  firstChild: Material(
                                    color: primarycolor,
                                    child: TabBar(
                                      onTap: (val) {
                                        if (kDebugMode) {
                                          print(controller.categories[val]);
                                        }
                                        if (controller.Detail.isNotEmpty) {
                                          controller.Detail.clear();
                                        } else {
                                          if (kDebugMode) {
                                            print('bdb');
                                          }
                                        }
                                        controller.printCategoryDetails(
                                            controller.categories[val]);
                                        selectedTab = val;
                                        setState(() {});
                                      },
                                      isScrollable:
                                          controller.categories.length > 9,
                                      tabs: List.generate(
                                          controller.categories.length,
                                          (index) {
                                        return controller.categories.isEmpty
                                            ? Container()
                                            : Tab(
                                                text: controller
                                                    .categories[index]
                                                    .toUpperCase(),
                                              );
                                      }),
                                    ),
                                  ),
                                  secondChild: Container(),
                                  crossFadeState: CrossFadeState.showFirst,
                                  duration: const Duration(milliseconds: 300),
                                ),
                                drawer: GetBuilder<HomeController>(
                                  init: HomeController(),
                                  builder: ((controller) {
                                    final User? user =
                                        controller.currentUser.value;
                                    if (user == null) {
                                      return const Center(
                                        child: Text('No user logged in.'),
                                      );
                                    } else {
                                      return Drawer(
                                        child: ListView(
                                          // Important: Remove any padding from the ListView.
                                          padding: EdgeInsets.zero,
                                          children: <Widget>[
                                            UserAccountsDrawerHeader(
                                              decoration: const BoxDecoration(
                                                  color: primarycolor),
                                              accountEmail:
                                                  Text(user.email.toString()),
                                              accountName: user.displayName ==
                                                      null
                                                  ? Container()
                                                  : Text(
                                                      user.displayName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 24),
                                                    ),
                                            ),
                                            controller.adminAccess.value
                                                ? ListTile(
                                                    leading: const Icon(
                                                        Icons.category),
                                                    title: const Text(
                                                        "Categories"),
                                                    onTap: () {
                                                      Get.toNamed(
                                                          ROUTE_CATEGORIES);
                                                    },
                                                  )
                                                : Container(),
                                            controller.adminAccess.value
                                                ? ListTile(
                                                    leading: const Icon(
                                                        Icons.add_box),
                                                    title:
                                                        const Text("Add Items"),
                                                    onTap: () {
                                                      Get.toNamed(
                                                          ROUTE_ADDITEMS);
                                                    },
                                                  )
                                                : Container(),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.point_of_sale_sharp),
                                              title: const Text('POS'),
                                              onTap: () {
                                                Get.toNamed(ROUTE_POS);
                                              },
                                            ),
                                            controller.adminAccess.value
                                                ? ListTile(
                                                    leading: const Icon(
                                                        Icons.shopping_cart),
                                                    title:
                                                        const Text("Purchase"),
                                                    onTap: () {
                                                      Get.toNamed(
                                                          ROUTE_PURCHASE);
                                                    },
                                                  )
                                                : Container(),
                                            controller.adminAccess.value
                                                ? ListTile(
                                                    leading: const Icon(
                                                        Icons.price_check),
                                                    title: const Text(
                                                        'Adjustment'),
                                                    onTap: () {
                                                      //Get.toNamed(ROUTE_ADJUSTMENT);
                                                    },
                                                  )
                                                : Container(),
                                            controller.adminAccess.value
                                                ? ListTile(
                                                    leading: const Icon(
                                                        Icons.person),
                                                    title:
                                                        const Text("Employee"),
                                                    onTap: () {
                                                      Get.toNamed(
                                                          ROUTE_EMPLOYEE);
                                                    },
                                                  )
                                                : Container(),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.bookmark_add_outlined),
                                              title: const Text("Attendances"),
                                              onTap: () {
                                                Get.toNamed(ROUTE_ATTENDANCE);
                                              },
                                            ),
                                            controller.adminAccess.value
                                                ? ListTile(
                                                    leading: const Icon(
                                                        Icons.payment),
                                                    title:
                                                        const Text("Payment"),
                                                    onTap: () {
                                                      Get.toNamed(
                                                          ROUTE_PAYMENT);
                                                    },
                                                  )
                                                : Container(),
                                            ListTile(
                                              leading: const Icon(Icons
                                                  .admin_panel_settings_outlined),
                                              title: const Text("Admin Access"),
                                              onTap: () {
                                                Get.toNamed(ROUTE_ADMINACCESS);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.logout),
                                              title: const Text("Logout"),
                                              onTap: () {
                                                FirebaseAuth.instance
                                                    .signOut()
                                                    .then((value) {
                                                  _prefs.setBool(
                                                      'isLoggedIn', false);
                                                  Get.offAllNamed(ROUTE_LOGIN);
                                                }).onError((error, stackTrace) {
                                                  showToast('can\'t logout');
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return DefaultTabController(
                      length: controller.categories.length,
                      child: Scaffold(
                        appBar: AppBar(
                          title: const Text('Home Page'),
                          backgroundColor: primarycolor,
                        ),
                        body: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: List<Widget>.generate(
                                controller.categories.length, (index) {
                              switch (_screen) {
                                case 0:
                                  if (controller.istabscreenloading.value) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    try {
                                      if (controller.Detail.isEmpty) {
                                        return const Center(
                                          child: Text('No Data '),
                                        );
                                      } else if (controller.Detail.isNotEmpty) {
                                        return AnimationLimiter(
                                          child: GridView.count(
                                            physics: const BouncingScrollPhysics(
                                                parent:
                                                    AlwaysScrollableScrollPhysics()),
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    60),
                                            crossAxisCount:
                                                MediaQuery.of(context)
                                                            .size
                                                            .shortestSide <
                                                        600
                                                    ? 3
                                                    : 4,
                                            children: List.generate(
                                              controller.Detail.length,
                                              (int index) {
                                                if (index >=
                                                    controller.Detail.length) {
                                                  return const SizedBox(); // Placeholder widget when index is out of range
                                                }

                                                final imageSize = MediaQuery.of(
                                                            context)
                                                        .size
                                                        .width /
                                                    4; // Adjust image size based on screen width
                                                final fontSize = MediaQuery.of(
                                                            context)
                                                        .size
                                                        .width *
                                                    0.03; // Adjust font size based on screen width
                                                final itemMargin = MediaQuery
                                                            .of(context)
                                                        .size
                                                        .width /
                                                    30; // Adjust margin based on screen width

                                                return AnimationConfiguration
                                                    .staggeredGrid(
                                                  position: index,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  columnCount: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .shortestSide <
                                                          600
                                                      ? 3
                                                      : 4,
                                                  child: ScaleAnimation(
                                                    duration: const Duration(
                                                        milliseconds: 900),
                                                    curve: Curves
                                                        .fastLinearToSlowEaseIn,
                                                    child: FadeInAnimation(
                                                      child: InkWell(
                                                        onLongPress:
                                                            controller
                                                                    .adminAccess
                                                                    .value
                                                                ? () {
                                                                    debugPrint(
                                                                        "Print Delete  current item name = ${controller.Detail[index].name}, current tab ${controller.categories[selectedTab!]}");
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return DialogBox(
                                                                          title:
                                                                              "Delete",
                                                                          content: controller
                                                                              .Detail[index]
                                                                              .name,
                                                                          context:
                                                                              context,
                                                                          function:
                                                                              () {
                                                                            controller.deleteSubCollectionItem(controller.categories[selectedTab!],
                                                                                controller.Detail[index].name);
                                                                            Navigator.of(context).pop(); // Close the dialog after the function is executed
                                                                          },
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                : () {
                                                                    debugPrint(
                                                                        "Don't have access");
                                                                  },
                                                        onTap: () {
                                                          controller.addItem(forPosTicketDetail(
                                                              description:
                                                                  controller
                                                                      .Detail[
                                                                          index]
                                                                      .description,
                                                              price: controller
                                                                  .Detail[index]
                                                                  .price,
                                                              image: controller
                                                                  .Detail[index]
                                                                  .image,
                                                              name: controller
                                                                  .Detail[index]
                                                                  .name));
                                                          if (kDebugMode) {
                                                            print(
                                                                '${controller.Detail[index].name} - ${controller.Detail[index].price}');
                                                          }
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              bottom:
                                                                  itemMargin,
                                                              left: itemMargin,
                                                              right:
                                                                  itemMargin),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1),
                                                                blurRadius: 40,
                                                                spreadRadius:
                                                                    10,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: Image
                                                                    .network(
                                                                  controller
                                                                      .Detail[
                                                                          index]
                                                                      .image,
                                                                  width:
                                                                      imageSize,
                                                                  height:
                                                                      imageSize,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  loadingBuilder:
                                                                      (context,
                                                                          child,
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null) {
                                                                      return child;
                                                                    }
                                                                    return const Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height:
                                                                      10), // Adjust the spacing between image and text
                                                              Text(
                                                                controller
                                                                    .Detail[
                                                                        index]
                                                                    .name,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontSize),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return AnimationLimiter(
                                            child: GridView.count(
                                          physics: const BouncingScrollPhysics(
                                              parent:
                                                  AlwaysScrollableScrollPhysics()),
                                          padding: EdgeInsets.all(w / 60),
                                          crossAxisCount: columnCount,
                                          children: List.generate(
                                            controller.Detail.length,
                                            (int index) {
                                              if (index >=
                                                  controller.Detail.length) {
                                                return const SizedBox(); // Placeholder widget when index is out of range
                                              }
                                              return AnimationConfiguration
                                                  .staggeredGrid(
                                                position: index,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                columnCount: columnCount,
                                                child: ScaleAnimation(
                                                  duration: const Duration(
                                                      milliseconds: 900),
                                                  curve: Curves
                                                      .fastLinearToSlowEaseIn,
                                                  child: FadeInAnimation(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: w / 30,
                                                          left: w / 60,
                                                          right: w / 60),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    20)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                            blurRadius: 40,
                                                            spreadRadius: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ));
                                      }
                                    } catch (e) {
                                      return Center(
                                        child: Text(e.toString()),
                                      );
                                    }
                                  }
                                default:
                                  return const Text('error');
                              }
                            }),
                          ),
                        ),
                        bottomNavigationBar: AnimatedCrossFade(
                          firstChild: Material(
                            color: primarycolor,
                            child: TabBar(
                              onTap: (val) {
                                if (kDebugMode) {
                                  print(controller.categories[val]);
                                }
                                if (controller.Detail.isNotEmpty) {
                                  controller.Detail.clear();
                                } else {
                                  if (kDebugMode) {
                                    print('bdb');
                                  }
                                }
                                controller.printCategoryDetails(
                                    controller.categories[val]);
                                selectedTab = val;
                                setState(() {});
                              },
                              isScrollable: controller.categories.length > 4,
                              tabs: List.generate(controller.categories.length,
                                  (index) {
                                return controller.categories.isEmpty
                                    ? Container()
                                    : Tab(
                                        text: controller.categories[index]
                                            .toUpperCase(),
                                      );
                              }),
                            ),
                          ),
                          secondChild: Container(),
                          crossFadeState: CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                        drawer: GetBuilder<HomeController>(
                          init: HomeController(),
                          builder: ((controller) {
                            final User? user = controller.currentUser.value;
                            if (user == null) {
                              return const Center(
                                child: Text('No user logged in.'),
                              );
                            } else {
                              return Drawer(
                                child: ListView(
                                  // Important: Remove any padding from the ListView.
                                  padding: EdgeInsets.zero,
                                  children: <Widget>[
                                    UserAccountsDrawerHeader(
                                      decoration: const BoxDecoration(
                                          color: primarycolor),
                                      accountEmail: Text(user.email.toString()),
                                      accountName: user.displayName == null
                                          ? Container()
                                          : Text(
                                              user.displayName.toString(),
                                              style:
                                                  const TextStyle(fontSize: 24),
                                            ),
                                    ),
                                    controller.adminAccess.value
                                        ? ListTile(
                                            leading: const Icon(Icons.category),
                                            title: const Text("Categories"),
                                            onTap: () {
                                              Get.toNamed(ROUTE_CATEGORIES);
                                            },
                                          )
                                        : Container(),
                                    controller.adminAccess.value
                                        ? ListTile(
                                            leading: const Icon(Icons.add_box),
                                            title: const Text("Add Items"),
                                            onTap: () {
                                              Get.toNamed(ROUTE_ADDITEMS);
                                            },
                                          )
                                        : Container(),
                                    ListTile(
                                      leading:
                                          const Icon(Icons.point_of_sale_sharp),
                                      title: const Text('POS'),
                                      onTap: () {
                                        Get.toNamed(ROUTE_POS);
                                      },
                                    ),
                                    controller.adminAccess.value
                                        ? ListTile(
                                            leading:
                                                const Icon(Icons.shopping_cart),
                                            title: const Text("Purchase"),
                                            onTap: () {
                                              Get.toNamed(ROUTE_PURCHASE);
                                            },
                                          )
                                        : Container(),
                                    controller.adminAccess.value
                                        ? ListTile(
                                            leading:
                                                const Icon(Icons.price_check),
                                            title: const Text('Adjustment'),
                                            onTap: () {
                                              //Get.toNamed(ROUTE_ADJUSTMENT);
                                            },
                                          )
                                        : Container(),
                                    controller.adminAccess.value
                                        ? ListTile(
                                            leading: const Icon(Icons.person),
                                            title: const Text("Employee"),
                                            onTap: () {
                                              Get.toNamed(ROUTE_EMPLOYEE);
                                            },
                                          )
                                        : Container(),
                                    ListTile(
                                      leading: const Icon(
                                          Icons.bookmark_add_outlined),
                                      title: const Text("Attendances"),
                                      onTap: () {
                                        Get.toNamed(ROUTE_ATTENDANCE);
                                      },
                                    ),
                                    controller.adminAccess.value
                                        ? ListTile(
                                            leading: const Icon(Icons.payment),
                                            title: const Text("Payment"),
                                            onTap: () {
                                              Get.toNamed(ROUTE_PAYMENT);
                                            },
                                          )
                                        : Container(),
                                    ListTile(
                                      leading: const Icon(
                                          Icons.admin_panel_settings_outlined),
                                      title: const Text("Admin Access"),
                                      onTap: () {
                                        Get.toNamed(ROUTE_ADMINACCESS);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.logout),
                                      title: const Text("Logout"),
                                      onTap: () {
                                        FirebaseAuth.instance
                                            .signOut()
                                            .then((value) {
                                          _prefs.setBool('isLoggedIn', false);
                                          Get.offAllNamed(ROUTE_LOGIN);
                                        }).onError((error, stackTrace) {
                                          showToast('can\'t logout');
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                    );
                  }
                }),
              ));
  }

  Widget _buildDataTable(RxList<forPosTicketDetail> detailList) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(() => SizedBox(
      height: screenHeight * 0.5,
      width: screenWidth / 2.5,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowHeight: 70.0,
          columnSpacing: 70.0,
          columns: const [
            DataColumn(label: Text('Item Name')),
            DataColumn(label: Text('Per Item')),
            DataColumn(label: Text('Item Quantity')),
            DataColumn(label: Text('Total Value')),
          ],
          rows: detailList.map((item) {
            final controller = Get.find<PosController>();
            return DataRow(
              cells: [
                DataCell(Text(
                  item.name!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                DataCell(Text(
                  '${item.price!} RM',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w100,
                  ),
                )),
                DataCell(
                  SizedBox(
                    child: Card(
                      elevation: 5,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => controller.decreaseItemCount(item),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Text(item.itemcount!.toString()),
                          SizedBox(width: screenWidth * 0.01),
                          InkWell(
                            onTap: () => controller.increaseItemCount(item),
                            child: const Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                DataCell(Text(
                  '${controller.calculateTotalValue(item).toString()} RM',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            );
          }).toList(),
        ),
      ),
    ));
  }

  Widget _buildActionButtons(PosController controller,HomeController homeController) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 55,
                  width: 175,
                  child: ElevatedButton(
                    onPressed:(){
                      if(controller.selectedTable.value == "Select the Table"){
                        Fluttertoast.showToast(msg: "Select The Table");
                      }else{
                        controller.clearTableData();
                      }

                    } ,
                    style: ElevatedButton.styleFrom(
                      primary: primarycolor,
                    ),
                    child: const Text(
                      "Clear",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: SizedBox(
                  height: 55,
                  width: 175,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SampleReceiptDialog();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: const Text('Show Receipt'),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: SizedBox(
                  height: 55,
                  width: 175,
                  child: ElevatedButton(
                    onPressed: () {
                      if(controller.selectedTable.value == "Select the Table"){
                        Fluttertoast.showToast(msg: "Select The Table");
                      }else{
                        controller.submitWithoutTime();
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      primary: primarycolor,
                    ),
                    child: const Text('Update'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 55,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){
                if(controller.selectedTable.value == "Select the Table"){
                  Fluttertoast.showToast(msg: "Select The Table");
                }else{
                  controller.Submit();
                }
              },
              style: ElevatedButton.styleFrom(
                primary: primarycolor,
              ),
              child: const Text(
                "Complete the Bill",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class SampleReceiptDialog extends StatefulWidget {
   SampleReceiptDialog({super.key});

  @override
  State<SampleReceiptDialog> createState() => _SampleReceiptDialogState();
}

class _SampleReceiptDialogState extends State<SampleReceiptDialog> {
   final controller = Get.find<PosController>();
   final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: controller.cash,
            decoration: const InputDecoration(
                labelText: 'Cash',
                suffix: Text("RM")
            ),
            onChanged: (val){
              controller.checkBalance();
              setState(() {

              });
            },
          ),
          const SizedBox(height: 10),
          Obx(() => Text("Balance : ${controller.balanceAmount.value} RM"))
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            double cashAmount = double.parse(controller.cash.text);
            double totalAmount = double.parse(controller.totalamount.value);
            print(cashAmount);
            print(totalAmount);
            if (cashAmount >= totalAmount) {
              homeController.printSampleReceipt("80", controller.cash.text, controller.balanceAmount.value);
            } else {
              Fluttertoast.showToast(msg: "Bill Amount is Not Matching");
            }


          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
