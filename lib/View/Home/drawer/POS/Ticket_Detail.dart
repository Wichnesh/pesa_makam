import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pesa_makanam_app/Controller/TicketDetailController.dart';
import 'package:pesa_makanam_app/utils/common_methods.dart';
import '../../../../Model/Homemodel.dart';
import '../../../../utils/colorUtils.dart';

class TicketDetail extends StatefulWidget {
  const TicketDetail({Key? key}) : super(key: key);

  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  @override
  Widget build(BuildContext context) {
    final TicketDetailController controller = Get.put(TicketDetailController());
    final screenWidth = MediaQuery.of(context).size.width;

    // Function to calculate the total amount for all items
    double calculateTotalAmount(List<forPosTicketDetail> items) {
      double totalAmount = 0.0;
      for (final item in items) {
        final count = item.itemcount ?? 0;
        final price = double.tryParse(item.price ?? '0') ?? 0.0;
        totalAmount += count * price;
      }
      controller.grandTotalAmount.value = totalAmount.toStringAsFixed(2);
      return totalAmount;
    }

    final totalAmount = controller.bill.isNotEmpty && controller.bill[0].items.isNotEmpty
        ? calculateTotalAmount(controller.bill[0].items)
        : 0.0;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Detail'),
        backgroundColor: primarycolor,
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.bill.isEmpty
            ? const Center(child: Text('No Data Available'))
            : SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Count')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Sub Total')),
                  ],
                  rows: controller.bill[0].items.map<DataRow>((item) {

                    return DataRow(cells: [

                      DataCell(Text(item.name ?? '')),

                      DataCell(TextFormField(
                        initialValue: item.itemcount?.toString() ?? '0',
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          // Update item count in the controller
                          controller.updateItemCount(controller.bill[0].items.indexOf(item), value);
                        },
                      )),

                      DataCell(Text(item.price ?? '')),

                      DataCell(Text(_calculateTotal(item))),
                    ]);
                  }).toList(),
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(70,0,0,0),
                  child: Text(
                    "Total Amount: ${controller.grandTotalAmount.value}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                  child: CustomElevatedButton(onPressed: (){
                for(var data in controller.bill[0].items){
                  if (kDebugMode) {
                    print("--${data.name}--${data.itemcount}--${data.price}");
                  }
                }
                controller.bill[0].totalAmount = totalAmount.toStringAsFixed(2);
                if (kDebugMode) {
                  print("total Amount ${controller.bill[0].totalAmount}");
                }
                controller.updateBill();
              }, label: "Update"))
            ],
          ),)
      ),
    );



  }

  String _calculateTotal(forPosTicketDetail item) {
    final count = item.itemcount ?? 0;
    final price = double.tryParse(item.price ?? '0') ?? 0.0;
    return (count * price).toStringAsFixed(2);
  }
}
