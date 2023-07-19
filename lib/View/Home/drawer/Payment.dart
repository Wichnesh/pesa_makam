import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pesa_makanam_app/Controller/Paymentcontroller.dart';
import 'package:pesa_makanam_app/utils/colorUtils.dart';

import '../../../Model/PaymentModel.dart';

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
          if (controller.isloading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: primarycolor,
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Screenheight * 0.02,
                    ),
                    Row(
                      children: [
                        Container(
                          height: Screenheight * 0.068,
                          width: Screenwidth * 0.5,
                          child: DropdownButtonFormField<Employee>(
                            value: controller.selectedEmployee,
                            onChanged: (employee) {
                              controller.selectedEmployee = employee;
                            },
                            items: controller.employeeList.map((employee) {
                              return DropdownMenuItem<Employee>(
                                onTap: () {
                                  controller.EmpId.value = employee.employeeId;
                                  print(employee.employeeId);
                                  controller.update();
                                },
                                value: employee,
                                child: Text(
                                    '${employee.name} - ${employee.employeeId}'),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Select Employee',
                              labelStyle: TextStyle(
                                color: primarycolor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        primarycolor), // Set the desired border color
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Screenwidth * 0.02,
                        ),
                        Expanded(
                          child: SizedBox(
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
                        ),
                        InkWell(
                          onTap: () {
                            if (controller.EmpId.value.isEmpty ||
                                controller.selectmonth.value == "Select") {
                              if (kDebugMode) {
                                print('error');
                              }
                            } else {
                              controller.fetchEmployeeRecords(
                                  controller.EmpId.value,
                                  controller.selectmonth.value);
                            }
                          },
                          child: Container(
                              width: Screenwidth * 0.13,
                              child: Icon(Icons.search)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Screenheight * 0.02,
                    ),
                    controller.showdetails.value
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: Screenheight * 0.068,
                                      child: TextField(
                                        readOnly: true,
                                        controller:
                                            controller.totalworkingdaysText
                                              ..text = controller
                                                  .totalworkingdays.value
                                                  .toString(),
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(fontSize: 18),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    primarycolor), // Set the desired border color
                                          ),
                                          labelText: 'Total days',
                                          labelStyle: TextStyle(
                                              fontSize: 14,
                                              color: primarycolor),
                                        ),
                                        onChanged: (val) {
                                          controller.perdaywages.value =
                                              int.parse(val);
                                          controller.update();
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Screenwidth * 0.04,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: Screenheight * 0.068,
                                      child: TextField(
                                        readOnly: true,
                                        controller: controller.workingdaysText
                                          ..text = controller.workingdays.value
                                              .toString(),
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(fontSize: 18),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    primarycolor), // Set the desired border color
                                          ),
                                          labelText: 'Working days',
                                          labelStyle: TextStyle(
                                              fontSize: 14,
                                              color: primarycolor),
                                        ),
                                        onChanged: (val) {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Screenheight * 0.02,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: Screenheight * 0.068,
                                      child: TextField(
                                        readOnly: true,
                                        controller: controller.perdaywagesText
                                          ..text = controller.perdaywages.value
                                              .toString(),
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(fontSize: 18),
                                        decoration: const InputDecoration(
                                          suffixText: 'RM',
                                          suffixStyle: TextStyle(
                                              fontSize: 18,
                                              color: primarycolor),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    primarycolor), // Set the desired border color
                                          ),
                                          labelText: 'per day wages',
                                          labelStyle: TextStyle(
                                              fontSize: 14,
                                              color: primarycolor),
                                        ),
                                        onChanged: (val) {
                                          controller.perdaywages.value =
                                              int.parse(val);
                                          controller.update();
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Screenwidth * 0.04,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: Screenheight * 0.068,
                                      child: TextField(
                                        readOnly: true,
                                        controller:
                                            controller.noofnonwrkeddaysText
                                              ..text = controller
                                                  .noofnonwrkeddays.value
                                                  .toString(),
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(
                                            fontSize: 18, color: Red),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    primarycolor), // Set the desired border color
                                          ),
                                          labelText: 'No. of. non-working days',
                                          labelStyle: TextStyle(
                                              fontSize: 14,
                                              color: primarycolor),
                                        ),
                                        onChanged: (val) {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Screenheight * 0.02,
                              ),
                              Container(
                                height: Screenheight * 0.068,
                                child: TextField(
                                  readOnly: true,
                                  controller: controller.monthlysalaryText
                                    ..text = controller.monthlysalary.value
                                        .toString(),
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    suffixText: 'RM',
                                    suffixStyle: TextStyle(
                                        fontSize: 18, color: primarycolor),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              primarycolor), // Set the desired border color
                                    ),
                                    labelText: 'This month total salary',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.perdaywages.value =
                                        int.parse(val);
                                    controller.update();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: Screenheight * 0.02,
                              ),
                              Container(
                                height: Screenheight * 0.068,
                                child: TextField(
                                  readOnly: true,
                                  controller: controller.deductionamtText
                                    ..text = controller.deductionamt.value
                                        .toString(),
                                  keyboardType: TextInputType.text,
                                  style:
                                      const TextStyle(fontSize: 18, color: Red),
                                  decoration: const InputDecoration(
                                    suffixText: 'RM',
                                    suffixStyle: TextStyle(
                                        fontSize: 18, color: primarycolor),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              primarycolor), // Set the desired border color
                                    ),
                                    labelText: 'deduction Amount',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.perdaywages.value =
                                        int.parse(val);
                                    controller.update();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: Screenheight * 0.02,
                              ),
                              Container(
                                height: Screenheight * 0.068,
                                child: TextField(
                                  readOnly: true,
                                  controller: controller.AdvanceamtText
                                    ..text =
                                        controller.Advance.value.toString(),
                                  keyboardType: TextInputType.text,
                                  style:
                                      const TextStyle(fontSize: 18, color: Red),
                                  decoration: const InputDecoration(
                                    suffixText: 'RM',
                                    suffixStyle: TextStyle(
                                        fontSize: 18, color: primarycolor),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              primarycolor), // Set the desired border color
                                    ),
                                    labelText: 'Advance Taken',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.Advance.value = int.parse(val);
                                    controller.update();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: Screenheight * 0.02,
                              ),
                              Container(
                                height: Screenheight * 0.068,
                                child: TextField(
                                  readOnly: true,
                                  controller: controller.payablesalaryText
                                    ..text = controller.payablesalary.value
                                        .toString(),
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    suffixText: 'RM',
                                    suffixStyle: TextStyle(
                                        fontSize: 18, color: primarycolor),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              primarycolor), // Set the desired border color
                                    ),
                                    labelText: 'payable Salary',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.perdaywages.value =
                                        int.parse(val);
                                    controller.update();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: Screenheight * 0.02,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Radio<PaymentType>(
                                      activeColor: primarycolor,
                                      value: PaymentType.Advance,
                                      groupValue: controller.paymentType.value,
                                      onChanged: (value) {
                                        controller.setPaymentType(value!);
                                        setState(() {});
                                      },
                                    ),
                                    Text('Advance'),
                                    Radio<PaymentType>(
                                      activeColor: primarycolor,
                                      value: PaymentType.Salary,
                                      groupValue: controller.paymentType.value,
                                      onChanged: (value) {
                                        controller.setPaymentType(value!);
                                        setState(() {});
                                      },
                                    ),
                                    Text('Salary'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Screenheight * 0.02,
                              ),
                              controller.Advancebool.value
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: Screenheight * 0.068,
                                          child: TextField(
                                            controller:
                                                controller.AdvanceavailableText,
                                            keyboardType: TextInputType.number,
                                            style:
                                                const TextStyle(fontSize: 18),
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        primarycolor), // Set the desired border color
                                              ),
                                              labelText: 'Advance Available',
                                              labelStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: primarycolor),
                                            ),
                                            onChanged: (val) {
                                              controller.update();
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: Screenheight * 0.02,
                                        ),
                                        Row(
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
                                                    controller.updateAdvanceAmount(
                                                        controller.EmpId.value,
                                                        int.parse(controller
                                                            .AdvanceavailableText
                                                            .text));
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: 165,
                                                    child: const Center(
                                                      child: Text(
                                                        "Pay Advance Amt",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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
                                                  child: const Text('Close'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
