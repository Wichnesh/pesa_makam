import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Controller/Adjustmentcontroller.dart';
import '../../../utils/colorUtils.dart';

class Adjustment_Screen extends StatefulWidget {
  const Adjustment_Screen({Key? key}) : super(key: key);

  @override
  State<Adjustment_Screen> createState() => _Adjustment_ScreenState();
}

class _Adjustment_ScreenState extends State<Adjustment_Screen> {
  final AdjustmentController adjustmentController =
      Get.put(AdjustmentController());
  @override
  Widget build(BuildContext context) {
    final Screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adjustment Sales & Purchase'),
        centerTitle: true,
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: TextField(
                    readOnly: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? date = DateTime.now();
                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());
                      if (date != null) {
                        adjustmentController.fromdate = date;
                        adjustmentController.update();
                      }
                    },
                    controller: adjustmentController.fromdatetext
                      ..text = DateFormat("dd-MM-yyyy").format(
                          adjustmentController.fromdate == null
                              ? DateTime.now()
                              : adjustmentController.fromdate ??
                                  DateTime.now()),
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today),
                      labelText: "From Date",
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: TextField(
                    readOnly: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? date = DateTime.now();

                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());

                      if (date != null) {
                        adjustmentController.todate = date;
                        adjustmentController.update();
                      }
                    },
                    controller: adjustmentController.todatetext
                      ..text = DateFormat("dd-MM-yyyy").format(
                          adjustmentController.todate == null
                              ? DateTime.now()
                              : adjustmentController.todate ?? DateTime.now()),
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today),
                      labelText: "To Date",
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Sale:'),
                          Checkbox(
                            value: adjustmentController.saleSelected.value,
                            onChanged: (value) {
                              adjustmentController.toggleSale();
                            },
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Purchase:'),
                          Checkbox(
                            value: adjustmentController.purchaseSelected.value,
                            onChanged: (value) {
                              adjustmentController.togglePurchase();
                            },
                          ),
                        ],
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
                                MaterialStateProperty.resolveWith<Color>(
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
                          onPressed: () {
                            if (adjustmentController.todatetext.text.isEmpty ||
                                adjustmentController
                                    .fromdatetext.text.isEmpty) {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Alert'),
                                  content: const Text(
                                      'Please enter From date & To date'),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              if (adjustmentController.saleSelected.value ==
                                      true &&
                                  adjustmentController.purchaseSelected.value ==
                                      true) {
                                adjustmentController.fetchSavedBillDataByDate();
                                adjustmentController.fetchPurchaseDataByDate();
                              } else if (adjustmentController
                                          .saleSelected.value ==
                                      true &&
                                  adjustmentController.purchaseSelected.value ==
                                      false) {
                                adjustmentController.fetchSavedBillDataByDate();
                              } else if (adjustmentController
                                          .saleSelected.value ==
                                      false &&
                                  adjustmentController.purchaseSelected.value ==
                                      true) {
                                adjustmentController.fetchPurchaseDataByDate();
                              } else {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text('Alert'),
                                    content: const Text(
                                        'Check any one box to Submit'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                          child: const SizedBox(
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
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        width: 175,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
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
                          child: const Text('Close'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GetBuilder<AdjustmentController>(
                builder: ((controller) {
                  if (adjustmentController.showdata.value) {
                    return SingleChildScrollView(
                        child: Column(
                      children: [
                        SizedBox(
                          height: Screenheight * 0.2,
                          child: DataTable(
                            dataRowHeight:
                                60, // Adjust the row height as needed
                            columns: const [
                              DataColumn(label: Text('')),
                              DataColumn(label: Text('')),
                            ],
                            rows: [
                              adjustmentController.saleSelected.value
                                  ? customDataRow(
                                      context,
                                      'Total Sales:',
                                      '${adjustmentController.adjTotalSalesAmount.toString()} RM',
                                    )
                                  : customDataRow(context, '', ''),
                              adjustmentController.purchaseSelected.value
                                  ? customDataRow(
                                      context,
                                      'Total Purchase:',
                                      '${adjustmentController.adjTotalPurchaseAmount.toString()} RM',
                                    )
                                  : customDataRow(context, '', ''),
                              customDataRow(
                                context,
                                'Net Amount:',
                                '${adjustmentController.adjTotalAmount.toString()} RM',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Screenheight * 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: TextField(
                              controller:
                                  adjustmentController.adjustmentPercentageText,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                suffix: Text('%'),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          primarycolor), // Set the desired border color
                                ),
                                labelText: 'Adjustment Percentage',
                                labelStyle: TextStyle(
                                    fontSize: 14, color: primarycolor),
                              ),
                              onChanged: (val) {
                                if (val == '') {
                                  adjustmentController.rollBack();
                                } else {
                                  adjustmentController
                                      .calculateAdjustedTotalAmount();
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 55,
                          width: 175,
                          child: Obx(() {
                            if (adjustmentController.isloading.value) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: primarycolor,
                              ));
                            } else {
                              return ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        // Change the button color when pressed
                                        return Colors.green;
                                      }
                                      // Return the default button color
                                      return primarycolor; // or any other color you want
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                            'Do you want to update?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              adjustmentController
                                                  .updateTotalAmountByPercentage();
                                              // Get.back();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Close the dialog and do nothing
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('No'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Update'),
                              );
                            }
                          }),
                        ),
                      ],
                    ));
                  } else {
                    return Container();
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  DataRow customDataRow(BuildContext context, String label, String value) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        DataCell(
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 22),
          ),
        ),
      ],
    );
  }
}
