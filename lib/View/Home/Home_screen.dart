import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pesa_makanam_app/Controller/homeController.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  int _screen = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => controller.isloading.value
          ? Scaffold(
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
                                return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                  ),
                                  itemCount: controller.Detail.length,
                                  itemBuilder: (context, index) {
                                    if (index >= controller.Detail.length) {
                                      return const SizedBox(); // Placeholder widget when index is out of range
                                    }
                                    return Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: GridTile(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Image.network(
                                                controller.Detail[index].image,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
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
                                              controller.Detail[index].name,
                                              style:
                                                  const TextStyle(fontSize: 24),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 4.0,
                                            mainAxisSpacing: 4.0),
                                    delegate: SliverChildBuilderDelegate(
                                        childCount: controller.Detail.length,
                                        (context, index) {
                                      if (index >= controller.Detail.length) {
                                        return const SizedBox(); // Placeholder widget when index is out of range
                                      }
                                      return GridTile(
                                        footer: Container(
                                          color: Colors.red,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              controller.Detail[index].name,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          height: 1,
                                          width: 20,
                                          child: Image.network(
                                            controller.Detail[index].image,
                                            fit: BoxFit.fitWidth,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              }
                            } catch (e) {
                              return Center(
                                child: Text(e.toString()),
                              );
                            }
                          }
                        default:
                          return Text('error');
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
                          print('bdb');
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
                  secondChild: new Container(),
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
                              decoration: BoxDecoration(color: primarycolor),
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
                              leading: Icon(Icons.add_box),
                              title: Text("Add Items"),
                              onTap: () {
                                Get.toNamed(ROUTE_ADDITEMS);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.shopping_cart),
                              title: Text("Purchase"),
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
                              leading: Icon(Icons.logout),
                              title: Text("Logout"),
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
