import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controller/homeController.dart';
import '../../../../utils/colorUtils.dart';

class ReceiptScreen extends StatelessWidget {
  final String? terminalContent;

  const ReceiptScreen({this.terminalContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: const Text('Receipt Preview'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 80 * 6, // Adjust the factor as needed for proper sizing
                height:
                    80 * 7.0, // Adjust the factor as needed for proper sizing
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Text(
                  terminalContent!,
                  style: const TextStyle(
                      fontFamily: 'Monospace'), // Use a monospaced font
                ),
              ),
              GetBuilder<HomeController>(
                init: HomeController(),
                builder: (controller) {
                  return ElevatedButton(
                      onPressed: () {
                        controller.printReceipt('80mm', context);
                      },
                      child: const Text('Print'));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
