import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:pesa_makanam_app/Controller/homeController.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final int _screen = 0;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    int columnCount = 4;
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => controller.isloading.value
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : DefaultTabController(
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
                                        MediaQuery.of(context).size.width / 60),
                                    crossAxisCount: MediaQuery.of(context)
                                                .size
                                                .shortestSide <
                                            600
                                        ? 3
                                        : 4,
                                    children: List.generate(
                                      controller.Detail.length,
                                      (int index) {
                                        if (index >= controller.Detail.length) {
                                          return const SizedBox(); // Placeholder widget when index is out of range
                                        }

                                        final imageSize = MediaQuery.of(context)
                                                .size
                                                .width /
                                            4; // Adjust image size based on screen width
                                        final fontSize = MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.04; // Adjust font size based on screen width
                                        final itemMargin = MediaQuery.of(
                                                    context)
                                                .size
                                                .width /
                                            30; // Adjust margin based on screen width

                                        return AnimationConfiguration
                                            .staggeredGrid(
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          columnCount: MediaQuery.of(context)
                                                      .size
                                                      .shortestSide <
                                                  600
                                              ? 3
                                              : 4,
                                          child: ScaleAnimation(
                                            duration: const Duration(
                                                milliseconds: 900),
                                            curve:
                                                Curves.fastLinearToSlowEaseIn,
                                            child: FadeInAnimation(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom: itemMargin,
                                                    left: itemMargin,
                                                    right: itemMargin),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 40,
                                                      spreadRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Image.network(
                                                        controller.Detail[index]
                                                            .image,
                                                        width: imageSize,
                                                        height: imageSize,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context,
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
                                                          .Detail[index].name,
                                                      style: TextStyle(
                                                          fontSize: fontSize),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
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
                                      parent: AlwaysScrollableScrollPhysics()),
                                  padding: EdgeInsets.all(w / 60),
                                  crossAxisCount: columnCount,
                                  children: List.generate(
                                    controller.Detail.length,
                                    (int index) {
                                      if (index >= controller.Detail.length) {
                                        return const SizedBox(); // Placeholder widget when index is out of range
                                      }
                                      return AnimationConfiguration
                                          .staggeredGrid(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        columnCount: columnCount,
                                        child: ScaleAnimation(
                                          duration:
                                              const Duration(milliseconds: 900),
                                          curve: Curves.fastLinearToSlowEaseIn,
                                          child: FadeInAnimation(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  bottom: w / 30,
                                                  left: w / 60,
                                                  right: w / 60),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
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
                        controller
                            .printCategoryDetails(controller.categories[val]);
                        setState(() {});
                      },
                      isScrollable: true,
                      tabs:
                          List.generate(controller.categories.length, (index) {
                        return Tab(
                          text: controller.categories[index].toUpperCase(),
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
                              decoration:
                                  const BoxDecoration(color: primarycolor),
                              accountEmail: Text(user.email.toString()),
                              accountName: null,
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
                              leading: const Icon(Icons.bookmark_add_outlined),
                              title: const Text("Attendances"),
                              onTap: () {
                                Get.toNamed(ROUTE_ATTENDANCE);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.payment),
                              title: const Text("Payment"),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text("Logout"),
                              onTap: () {
                                FirebaseAuth.instance.signOut().then((value) {
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
            ),
    );
  }
}
