import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pesa_makanam_app/Controller/Paymentcontroller.dart';
import 'package:pesa_makanam_app/utils/colorUtils.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final Screenheight = MediaQuery.of(context).size.height;
    final Screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: primarycolor,
      ),
      body: GetBuilder(
        init: PaymentController(),
        builder: ((controller) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: Screenheight * 0.068,
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
                            labelText: 'Emp Id',
                            labelStyle:
                                TextStyle(fontSize: 14, color: primarycolor),
                          ),
                          onChanged: (val) {
                            controller.EmpId.value = val;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Screenwidth * 0.02,
                    ),
                    GetBuilder(
                        init: PaymentController(),
                        builder: ((controller) {
                          return Expanded(
                            child: Container(
                              height: Screenheight * 0.068,
                              width: double.infinity,
                              child: DropdownButtonFormField(
                                hint: Text(
                                  controller.selectmonth.value,
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
                                  labelText: "Month*",
                                  labelStyle: TextStyle(
                                      fontSize: 14, color: primarycolor),
                                  border: OutlineInputBorder(),
                                ),
                                items: controller.month.map(
                                  (val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(
                                        val,
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  controller.updateMonth(val);
                                  print(
                                      "val:    ${controller.selectmonth.value}");
                                },
                              ),
                            ),
                          );
                        })),
                    GetBuilder(
                        init: PaymentController(),
                        builder: ((controller) {
                          return InkWell(
                            onTap: () {
                              if (controller.EmpId.value.isEmpty ||
                                  controller.selectmonth.value == "Select") {
                                print('error');
                              } else {
                                controller.fetchEmployeeRecords(
                                    controller.EmpId.value,
                                    controller.selectmonth.value);
                              }
                            },
                            child: Container(
                                width: Screenwidth * 0.13,
                                child: Icon(Icons.search)),
                          );
                        }))
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
