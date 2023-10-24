import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../Controller/PosController.dart';
import '../../../../utils/colorUtils.dart';

class TicketList extends StatefulWidget {
  const TicketList({Key? key}) : super(key: key);

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  final PosController posController = Get.put(PosController());
  @override
  Widget build(BuildContext context) {
    final Screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket List'),
        centerTitle: true,
        backgroundColor: primarycolor,
      ),
      body: Padding(
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
                      posController.fromdate = date;
                      posController.update();
                    }
                  },
                  controller: posController.fromdatetext
                    ..text = DateFormat("dd-MM-yyyy").format(
                        posController.fromdate == null
                            ? DateTime.now()
                            : posController.fromdate ?? DateTime.now()),
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
                      posController.todate = date;
                      posController.update();
                    }
                  },
                  controller: posController.todatetext
                    ..text = DateFormat("dd-MM-yyyy").format(
                        posController.todate == null
                            ? DateTime.now()
                            : posController.todate ?? DateTime.now()),
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today),
                    labelText: "To Date",
                    labelStyle: TextStyle(fontSize: 14),
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
                          if (posController.todatetext.text.isEmpty ||
                              posController.fromdatetext.text.isEmpty) {
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
                            posController.fetchSavedBillDatabydate();
                            setState(() {});
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
                              return Colors.red; // or any other color you want
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
            GetBuilder<PosController>(
              builder: ((controller) {
                if (posController.showdata.value) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: posController.filterBills.length,
                      itemBuilder: (context, index) {
                        final bill = posController.filterBills[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(
                                  'Date: ${bill.date.split('-').sublist(0, 3).join('-')}'),
                              subtitle:
                                  Text('Total Amount: ${bill.totalAmount} RM'),
                              // Display items here
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
