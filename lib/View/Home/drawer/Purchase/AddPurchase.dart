import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesa_makanam_app/Controller/AddPurchaseController.dart';

import '../../../../utils/colorUtils.dart';

class AddPurchase extends StatefulWidget {
  const AddPurchase({Key? key}) : super(key: key);

  @override
  State<AddPurchase> createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {
  @override
  Widget build(BuildContext context) {
    final Screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Purchase'),
        backgroundColor: primarycolor,
        centerTitle: true,
      ),
      body: GetBuilder<AddPurchaseController>(
        builder: ((controller) {
          return SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                height: Screenheight * 0.9,
                child: Column(
                  children: [
                    SizedBox(
                        height: Screenheight * 0.1,
                        child: Image.asset("assets/images/logo.png")),
                    SizedBox(height: Screenheight * 0.005),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      primarycolor), // Set the desired border color
                            ),
                            labelText: 'Vendor Name',
                            labelStyle:
                                TextStyle(fontSize: 14, color: primarycolor),
                          ),
                          onChanged: (val) {
                            controller.vendorname.value = val;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: Screenheight * 0.005),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffix: Text('RM'),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      primarycolor), // Set the desired border color
                            ),
                            labelText: 'Amount',
                            labelStyle:
                                TextStyle(fontSize: 14, color: primarycolor),
                          ),
                          onChanged: (val) {
                            controller.Amount.value = val;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: Screenheight * 0.005),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      primarycolor), // Set the desired border color
                            ),
                            labelText: 'Tax percentage',
                            labelStyle:
                                TextStyle(fontSize: 14, color: primarycolor),
                          ),
                          onChanged: (val) {
                            controller.taxpercentage.value = val;
                            controller.calculateAmounts();
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: Screenheight * 0.005),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextField(
                          controller: controller.TaxAmountText
                            ..text = controller.taxamount.value,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            suffix: Text('RM'),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      primarycolor), // Set the desired border color
                            ),
                            labelText: 'Tax Amount',
                            labelStyle:
                                TextStyle(fontSize: 14, color: primarycolor),
                          ),
                          onChanged: (val) {
                            controller.Amount.value = val;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: Screenheight * 0.005),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextField(
                          controller: controller.TotalAmountText
                            ..text = controller.Totalamount.value,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffix: Text('RM'),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      primarycolor), // Set the desired border color
                            ),
                            labelText: 'Total Amount',
                            labelStyle:
                                TextStyle(fontSize: 14, color: primarycolor),
                          ),
                          onChanged: (val) {
                            controller.Amount.value = val;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.4),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
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
                            controller.OrderselectedDate = date;
                            controller.orderdateText.value =
                                DateFormat("dd-MM-yyyy").format(date!);
                            controller.update();
                          },
                          controller: controller.OrderDateText
                            ..text = controller.orderdateText.value,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.calendar_today),
                            labelText: "Order Date*",
                            labelStyle:
                                TextStyle(fontSize: 14, color: primarycolor),
                            border:
                                InputBorder.none, // Remove the default border
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                          ),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'Net Payment',
                        style: TextStyle(
                          color: primarycolor, // Use the primary color here
                        ),
                      ),
                      value: controller.isChecked.value,
                      onChanged: (bool? value) {
                        controller.setChecked(value ?? false);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.4),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
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
                            controller.OrderselectedDate = date;
                            controller.pendingdateText.value =
                                DateFormat("dd-MM-yyyy").format(date!);
                            if (kDebugMode) {
                              print(controller.pendingdateText.value);
                            }
                            controller.update();
                          },
                          controller: controller.PendingDateText
                            ..text = controller.pendingdateText.value,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.calendar_today),
                            labelText: "Pending Date*",
                            labelStyle:
                                TextStyle(fontSize: 14, color: primarycolor),
                            border:
                                InputBorder.none, // Remove the default border
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                          ),
                        ),
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
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        // Change the button color when pressed
                                        return Colors.green;
                                      }
                                      // Return the default button color
                                      return primarycolor;
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  controller.submitDataToFirestore();
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
                                      if (states
                                          .contains(MaterialState.pressed)) {
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
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
