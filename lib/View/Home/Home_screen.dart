import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:pesa_makanam_app/Controller/homeController.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final int _screen = 0;
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
                              body: GetBuilder<PosController>(
                                init: PosController(),
                                builder: ((controller) =>
                                    controller.isloading.value
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : controller.detailList.isEmpty
                                            ? const Center(
                                                child:
                                                    Text('No Data Available'),
                                              )
                                            : SingleChildScrollView(
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
                                                                : SingleChildScrollView(
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(1.0),
                                                                        child: SizedBox(
                                                                            height: screenHeight * 0.5,
                                                                            width: screenWidth * 0.55,
                                                                            child: SingleChildScrollView(
                                                                              scrollDirection: Axis.horizontal,
                                                                              child: SingleChildScrollView(
                                                                                scrollDirection: Axis.vertical,
                                                                                child: DataTable(
                                                                                  headingRowHeight: 50.0,
                                                                                  columnSpacing: 15.0,
                                                                                  columns: const [
                                                                                    DataColumn(
                                                                                      label: Text('Item Name', style: TextStyle(color: Colors.black)),
                                                                                    ),
                                                                                    DataColumn(
                                                                                      label: Text('Per Item', style: TextStyle(color: Colors.black)),
                                                                                    ),
                                                                                    DataColumn(
                                                                                      label: Text('Item Quantity', style: TextStyle(color: Colors.black)),
                                                                                    ),
                                                                                    DataColumn(
                                                                                      label: Text('Total Value', style: TextStyle(color: Colors.black)),
                                                                                    ),
                                                                                  ],
                                                                                  rows: controller.detailList
                                                                                      .map(
                                                                                        (item) => DataRow(
                                                                                          cells: [
                                                                                            DataCell(
                                                                                              Text(
                                                                                                item.name!,
                                                                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                            DataCell(
                                                                                              Text(
                                                                                                '${item.price!} RM',
                                                                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                                                                                              ),
                                                                                            ),
                                                                                            DataCell(
                                                                                              SizedBox(
                                                                                                child: Card(
                                                                                                  elevation: 5,
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      InkWell(
                                                                                                        onTap: () {
                                                                                                          controller.decreaseItemCount(item);
                                                                                                          setState(() {});
                                                                                                        },
                                                                                                        child: const Icon(
                                                                                                          Icons.remove,
                                                                                                          color: Colors.red,
                                                                                                        ),
                                                                                                      ),
                                                                                                      SizedBox(width: screenWidth * 0.01),
                                                                                                      Text(item.itemcount!.toString()),
                                                                                                      SizedBox(width: screenWidth * 0.01),
                                                                                                      InkWell(
                                                                                                        onTap: () {
                                                                                                          controller.increaseItemCount(item);
                                                                                                          setState(() {});
                                                                                                        },
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
                                                                                            DataCell(
                                                                                              Text(
                                                                                                '${controller.calculateTotalValue(item).toString()} RM',
                                                                                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                      .toList(),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ),
                                                      ),
                                                      GetBuilder<PosController>(
                                                        init: PosController(),
                                                        builder: ((controller) {
                                                          double amount = controller
                                                              .calculateTotalAmount();
                                                          controller.totalamount
                                                                  .value =
                                                              amount.toString();
                                                          return Text(
                                                            'Total Amount : $amount RM',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 24),
                                                          );
                                                        }),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            screenHeight * 0.05,
                                                      ),
                                                      GetBuilder<PosController>(
                                                          init: PosController(),
                                                          builder:
                                                              ((controller) {
                                                            return Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              55,
                                                                          width:
                                                                              175,
                                                                          color:
                                                                              primarycolor,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ButtonStyle(
                                                                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                                                (Set<MaterialState> states) {
                                                                                  if (states.contains(MaterialState.pressed)) {
                                                                                    // Change the button color when pressed
                                                                                    return Colors.green;
                                                                                  }
                                                                                  // Return the default button color
                                                                                  return primarycolor;
                                                                                },
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              controller.clear();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 50,
                                                                              width: 165,
                                                                              child: const Center(
                                                                                child: Text(
                                                                                  "Clear",
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            15,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              55,
                                                                          width:
                                                                              175,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ButtonStyle(
                                                                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                                                (Set<MaterialState> states) {
                                                                                  if (states.contains(MaterialState.pressed)) {
                                                                                    // Change the button color when pressed
                                                                                    return Colors.green;
                                                                                  }
                                                                                  // Return the default button color
                                                                                  return Colors.red; // or any other color you want
                                                                                },
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              // Handle the button click event
                                                                              Get.back();
                                                                            },
                                                                            child:
                                                                                Text('Close'),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              55,
                                                                          width:
                                                                              175,
                                                                          color:
                                                                              primarycolor,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ButtonStyle(
                                                                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                                                (Set<MaterialState> states) {
                                                                                  if (states.contains(MaterialState.pressed)) {
                                                                                    // Change the button color when pressed
                                                                                    return Colors.green;
                                                                                  }
                                                                                  // Return the default button color
                                                                                  return primarycolor;
                                                                                },
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              controller.Submit();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 50,
                                                                              width: 165,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Submit",
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }))
                                                    ],
                                                  ),
                                                ),
                                              )),
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
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              10,
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
                                                                        style: TextStyle(
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
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.category),
                                              title: const Text("Categories"),
                                              onTap: () {
                                                Get.toNamed(ROUTE_CATEGORIES);
                                              },
                                            ),
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.add_box),
                                              title: const Text("Add Items"),
                                              onTap: () {
                                                Get.toNamed(ROUTE_ADDITEMS);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.point_of_sale_sharp),
                                              title: const Text('POS'),
                                              onTap: () {
                                                Get.toNamed(ROUTE_POS);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.shopping_cart),
                                              title: const Text("Purchase"),
                                              onTap: () {
                                                Get.toNamed(ROUTE_PURCHASE);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.person),
                                              title: const Text("Employee"),
                                              onTap: () {
                                                Get.toNamed(ROUTE_EMPLOYEE);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.bookmark_add_outlined),
                                              title: const Text("Attendances"),
                                              onTap: () {
                                                Get.toNamed(ROUTE_ATTENDANCE);
                                              },
                                            ),
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.payment),
                                              title: const Text("Payment"),
                                              onTap: () {
                                                Get.toNamed(ROUTE_PAYMENT);
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
                                    ListTile(
                                      leading: const Icon(Icons.category),
                                      title: const Text("Categories"),
                                      onTap: () {
                                        Get.toNamed(ROUTE_CATEGORIES);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.add_box),
                                      title: const Text("Add Items"),
                                      onTap: () {
                                        Get.toNamed(ROUTE_ADDITEMS);
                                      },
                                    ),
                                    ListTile(
                                      leading:
                                          const Icon(Icons.point_of_sale_sharp),
                                      title: const Text('POS'),
                                      onTap: () {
                                        Get.toNamed(ROUTE_POS);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.shopping_cart),
                                      title: const Text("Purchase"),
                                      onTap: () {
                                        Get.toNamed(ROUTE_PURCHASE);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.person),
                                      title: const Text("Employee"),
                                      onTap: () {
                                        Get.toNamed(ROUTE_EMPLOYEE);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                          Icons.bookmark_add_outlined),
                                      title: const Text("Attendances"),
                                      onTap: () {
                                        Get.toNamed(ROUTE_ATTENDANCE);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.payment),
                                      title: const Text("Payment"),
                                      onTap: () {
                                        Get.toNamed(ROUTE_PAYMENT);
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
}
