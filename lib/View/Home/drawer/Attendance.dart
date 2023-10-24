import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:slider_button/slider_button.dart';

import '../../../Controller/AttendanceController.dart';
import '../../../Controller/EmployeeController.dart';
import '../../../utils/colorUtils.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final ScreenHeight = MediaQuery.of(context).size.height;
    final ScreenWeight = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primarycolor,
          title: const Text('Attendance'),
        ),
        body: LayoutBuilder(
          builder: (context, constraint) {
            if (isLandscape) {
              return GetBuilder<AttendanceController>(
                init: AttendanceController(),
                builder: ((controller) {
                  if (controller.isloading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: ScreenHeight * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: ScreenHeight * 0.2,
                              width: double.infinity,
                              child: DropdownButtonFormField(
                                hint: Text(
                                  controller.selectemployeename.value,
                                ),
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 25,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            primarycolor), // Set the desired border color
                                  ),
                                  labelText: "Employee Name*",
                                  labelStyle: TextStyle(
                                      fontSize: 14, color: primarycolor),
                                  border: OutlineInputBorder(),
                                ),
                                items: controller.employeenamelist.map(
                                  (val) {
                                    return DropdownMenuItem<String>(
                                      value: val.name,
                                      child: Text(
                                        val.name.toString(),
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  controller.updateEmployeename(val);
                                  controller.showinout.value = false;
                                  controller.checkinbool.value = true;
                                  print(controller.showinout.value);
                                  controller.fetchEmployeeByName();
                                  print(
                                      "val:    ${controller.selectemployeename.value}");
                                },
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10.00),
                              child: controller.showinout.value
                                  ? Container()
                                  : Column(
                                      children: [
                                        Container(
                                          height: 150,
                                          margin: const EdgeInsets.only(
                                              top: 12, bottom: 32),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 10,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Check - In',
                                                      style: TextStyle(
                                                        fontSize:
                                                            ScreenWeight / 20,
                                                      ),
                                                    ),
                                                    controller.checkintime.value
                                                            .isEmpty
                                                        ? Text(
                                                            '--/--',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenWeight /
                                                                        18,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                        : Text(
                                                            '${controller.checkintime}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenWeight /
                                                                        18,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                  ],
                                                ),
                                              )),
                                              Expanded(
                                                  child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Check - Out',
                                                      style: TextStyle(
                                                        fontSize:
                                                            ScreenWeight / 20,
                                                      ),
                                                    ),
                                                    controller.checkouttime
                                                            .value.isEmpty
                                                        ? Text(
                                                            '--/--',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenWeight /
                                                                        18,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                        : Text(
                                                            '${controller.checkouttime}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenWeight /
                                                                        18,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: DateFormat('dd')
                                                      .format(DateTime.now()),
                                                  style: TextStyle(
                                                    fontSize: ScreenWeight / 20,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: DateFormat(' MMMM yyyy')
                                                      .format(DateTime.now()),
                                                  style: TextStyle(
                                                    fontSize: ScreenWeight / 20,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: ScreenHeight * 0.15,
                                        ),
                                        controller.displayslider.value
                                            ? Center(
                                                child: controller
                                                        .checkinbool.value
                                                    ? SliderButton(
                                                        action: () {
                                                          ///Do something
                                                          if (kDebugMode) {
                                                            print(
                                                                'check - out done');
                                                          }
                                                          controller.Checkout();
                                                        },
                                                        label: const Text(
                                                          "Slide to Check - Out",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 17),
                                                        ),
                                                        icon: const Icon(
                                                          Icons
                                                              .arrow_forward_rounded,
                                                          size: 44,
                                                          color: Colors.white,
                                                        ),

                                                        ///Change All the color and size from here.
                                                        buttonColor:
                                                            primarycolor,
                                                        highlightedColor:
                                                            Colors.white,
                                                        baseColor: Red,
                                                      )
                                                    : SliderButton(
                                                        action: () {
                                                          ///Do something
                                                          controller.Checkin();
                                                          if (kDebugMode) {
                                                            print('hello');
                                                          }
                                                        },
                                                        label: const Text(
                                                          "Slide to Check - In",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff4a4a4a),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 17),
                                                        ),
                                                        icon: const Icon(
                                                          Icons
                                                              .arrow_forward_rounded,
                                                          size: 44,
                                                          color: white,
                                                        ),

                                                        ///Change All the color and size from here.
                                                        buttonColor:
                                                            primarycolor,
                                                        highlightedColor:
                                                            Colors.white,
                                                        baseColor: primarycolor,
                                                      ))
                                            : Container()
                                      ],
                                    ))
                        ],
                      ),
                    );
                  }
                }),
              );
            } else {
              return GetBuilder<AttendanceController>(
                init: AttendanceController(),
                builder: ((controller) {
                  if (controller.isloading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: ScreenHeight * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: ScreenHeight * 0.1,
                              width: double.infinity,
                              child: DropdownButtonFormField(
                                hint: Text(
                                  controller.selectemployeename.value,
                                ),
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 25,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            primarycolor), // Set the desired border color
                                  ),
                                  labelText: "Employee Name*",
                                  labelStyle: TextStyle(
                                      fontSize: 14, color: primarycolor),
                                  border: OutlineInputBorder(),
                                ),
                                items: controller.employeenamelist.map(
                                  (val) {
                                    return DropdownMenuItem<String>(
                                      value: val.name,
                                      child: Text(
                                        val.name.toString(),
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  controller.updateEmployeename(val);
                                  controller.showinout.value = false;
                                  controller.checkinbool.value = true;
                                  print(controller.showinout.value);
                                  controller.fetchEmployeeByName();
                                  print(
                                      "val:    ${controller.selectemployeename.value}");
                                },
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10.00),
                              child: controller.showinout.value
                                  ? Container()
                                  : Column(
                                      children: [
                                        Container(
                                          height: 150,
                                          margin: const EdgeInsets.only(
                                              top: 12, bottom: 32),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 10,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Check - In',
                                                      style: TextStyle(
                                                        fontSize:
                                                            ScreenWeight / 20,
                                                      ),
                                                    ),
                                                    controller.checkintime.value
                                                            .isEmpty
                                                        ? Text(
                                                            '--/--',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenWeight /
                                                                        18,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                        : Text(
                                                            '${controller.checkintime}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenWeight /
                                                                        18,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                  ],
                                                ),
                                              )),
                                              Expanded(
                                                  child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Check - Out',
                                                      style: TextStyle(
                                                        fontSize:
                                                            ScreenWeight / 20,
                                                      ),
                                                    ),
                                                    controller.checkouttime
                                                            .value.isEmpty
                                                        ? Text(
                                                            '--/--',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenWeight /
                                                                        18,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                        : Text(
                                                            '${controller.checkouttime}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenWeight /
                                                                        18,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: DateFormat('dd')
                                                      .format(DateTime.now()),
                                                  style: TextStyle(
                                                    fontSize: ScreenWeight / 20,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: DateFormat(' MMMM yyyy')
                                                      .format(DateTime.now()),
                                                  style: TextStyle(
                                                    fontSize: ScreenWeight / 20,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: ScreenHeight * 0.15,
                                        ),
                                        controller.displayslider.value
                                            ? Center(
                                                child: controller
                                                        .checkinbool.value
                                                    ? SliderButton(
                                                        action: () {
                                                          ///Do something
                                                          if (kDebugMode) {
                                                            print(
                                                                'check - out done');
                                                          }
                                                          controller.Checkout();
                                                        },
                                                        label: const Text(
                                                          "Slide to Check - Out",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 17),
                                                        ),
                                                        icon: const Icon(
                                                          Icons
                                                              .arrow_forward_rounded,
                                                          size: 44,
                                                          color: Colors.white,
                                                        ),

                                                        ///Change All the color and size from here.
                                                        buttonColor:
                                                            primarycolor,
                                                        highlightedColor:
                                                            Colors.white,
                                                        baseColor: Red,
                                                      )
                                                    : SliderButton(
                                                        action: () {
                                                          ///Do something
                                                          controller.Checkin();
                                                          if (kDebugMode) {
                                                            print('hello');
                                                          }
                                                        },
                                                        label: const Text(
                                                          "Slide to Check - In",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff4a4a4a),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 17),
                                                        ),
                                                        icon: const Icon(
                                                          Icons
                                                              .arrow_forward_rounded,
                                                          size: 44,
                                                          color: white,
                                                        ),

                                                        ///Change All the color and size from here.
                                                        buttonColor:
                                                            primarycolor,
                                                        highlightedColor:
                                                            Colors.white,
                                                        baseColor: primarycolor,
                                                      ))
                                            : Container()
                                      ],
                                    ))
                        ],
                      ),
                    );
                  }
                }),
              );
            }
          },
        ));
  }
}
