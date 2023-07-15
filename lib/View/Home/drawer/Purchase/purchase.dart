import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pesa_makanam_app/utils/colorUtils.dart';
import 'package:pesa_makanam_app/utils/constant.dart';

import '../../../../Controller/PurchaseController.dart';

class Purchase extends StatefulWidget {
  const Purchase({Key? key}) : super(key: key);

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text('Purchase'),
        centerTitle: true,
      ),
      body: GetBuilder<PurchaseController>(
        builder: ((controller) {
          if (controller.purchases.isEmpty) {
            return const Center(child: Text('No Data Available'));
          } else {
            return ListView.builder(
                itemCount: controller.purchases.length,
                itemBuilder: (context, index) {
                  final purchase = controller.purchases[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                purchase.vendorName!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              Text(
                                purchase.payment!,
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                ' ₹ ${purchase.totalAmount}',
                                style: TextStyle(
                                    color: primarycolor, fontSize: 20),
                              ),
                              Text(purchase.orderDate!)
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primarycolor,
        onPressed: () {
          Get.toNamed(ROUTE_ADDPURCHASE);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
