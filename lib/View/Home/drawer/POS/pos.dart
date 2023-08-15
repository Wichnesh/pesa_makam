import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pesa_makanam_app/Model/Homemodel.dart';
import 'package:pesa_makanam_app/utils/colorUtils.dart';
import '../../../../Controller/PosController.dart';
import '../../../../utils/constant.dart';

class Pos_screen extends StatefulWidget {
  const Pos_screen({Key? key}) : super(key: key);

  @override
  State<Pos_screen> createState() => _Pos_screenState();
}

class _Pos_screenState extends State<Pos_screen> {
  final PosController posController = Get.put(PosController());
  double tabletWidth = 0.0;
  double landscapeWidth = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Calculate dynamic values for tablet and landscape widths
    tabletWidth = MediaQuery.of(context).size.width *
        1; // For example, 70% of screen width
    landscapeWidth = MediaQuery.of(context).size.width *
        1; // For example, 90% of screen width
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double width;

    if (MediaQuery.of(context).size.width > 600) {
      width = tabletWidth;
      if (kDebugMode) {
        print('tablet');
      }
    } else if (MediaQuery.of(context).orientation == Orientation.landscape) {
      width = landscapeWidth;
      if (kDebugMode) {
        print('landscape');
      }
    } else {
      width = screenWidth * 1.4;
      if (kDebugMode) {
        print('mobile portrait');
      }
    }

    double calculateSizedBoxHeight(int listLength) {
      if (listLength == 3) {
        return screenHeight * 0.3;
      } else if (listLength == 5) {
        return screenHeight * 0.35;
      } else if (listLength == 8) {
        return screenHeight * 0.5;
      } else {
        // Default height if none of the above conditions match
        return 0.0;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(ROUTE_TICKETLIST);
              },
              icon: const Icon(
                Icons.list,
                color: Colors.white,
              )),
          SizedBox(
            width: screenWidth * 0.05,
          )
        ],
        backgroundColor: primarycolor,
      ),
      body: GetBuilder<PosController>(
        init: PosController(),
        builder: ((_controller) => _controller.isloading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _controller.detailList.isEmpty
                ? const Center(
                    child: Text('No Data Available'),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Card(
                              child: ListTile(
                            title: Text(
                              'Dine in',
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Icon(Icons.arrow_drop_down_sharp),
                          )),
                          GetBuilder<PosController>(
                            init: PosController(),
                            builder: (controller) => controller.isloading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : SingleChildScrollView(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SizedBox(
                                          height: screenHeight * 0.5,
                                          width: width,
                                          child: SingleChildScrollView(
                                            child: DataTable(
                                              columns: const [
                                                DataColumn(
                                                  label: Expanded(
                                                    flex: 2,
                                                    child: Text('Item Name'),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                    flex: 3,
                                                    child: Text('Per Item'),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                    flex: 1,
                                                    child:
                                                        Text('Item Quantity'),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                    flex: 2,
                                                    child: Text('Total Value'),
                                                  ),
                                                ),
                                              ],
                                              rows: controller.detailList
                                                  .map(
                                                    (item) => DataRow(
                                                      cells: [
                                                        DataCell(
                                                          Text(
                                                            item.name!,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            '${item.price!} RM',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          SizedBox(
                                                            width: screenWidth *
                                                                0.2,
                                                            child: Card(
                                                              elevation: 5,
                                                              child: Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      controller
                                                                          .decreaseItemCount(
                                                                              item);
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        screenWidth *
                                                                            0.01,
                                                                  ),
                                                                  Text(item
                                                                      .itemcount!
                                                                      .toString()),
                                                                  SizedBox(
                                                                    width:
                                                                        screenWidth *
                                                                            0.01,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      controller
                                                                          .increaseItemCount(
                                                                              item);
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .green,
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
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          GetBuilder<PosController>(
                            init: PosController(),
                            builder: ((controller) {
                              double amount = controller.calculateTotalAmount();
                              controller.totalamount.value = amount.toString();
                              return Text(
                                'Total Amount : $amount RM',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              );
                            }),
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          GetBuilder<PosController>(
                              init: PosController(),
                              builder: ((controller) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 55,
                                              width: 175,
                                              color: primarycolor,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .pressed)) {
                                                        // Change the button color when pressed
                                                        return Colors.green;
                                                      }
                                                      // Return the default button color
                                                      return primarycolor;
                                                    },
                                                  ),
                                                ),
                                                onPressed: () {
                                                  controller.clear();
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 165,
                                                  child: const Center(
                                                    child: Text(
                                                      "Clear",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 55,
                                              width: 175,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .pressed)) {
                                                        // Change the button color when pressed
                                                        return Colors.green;
                                                      }
                                                      // Return the default button color
                                                      return Colors
                                                          .red; // or any other color you want
                                                    },
                                                  ),
                                                ),
                                                onPressed: () {
                                                  // Handle the button click event
                                                  Get.back();
                                                },
                                                child: Text('Close'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 55,
                                              width: 175,
                                              color: primarycolor,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .pressed)) {
                                                        // Change the button color when pressed
                                                        return Colors.green;
                                                      }
                                                      // Return the default button color
                                                      return primarycolor;
                                                    },
                                                  ),
                                                ),
                                                onPressed: () {
                                                  controller.Submit();
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 165,
                                                  child: Center(
                                                    child: Text(
                                                      "Submit",
                                                      style: TextStyle(
                                                          color: Colors.white),
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
    );
  }
}
