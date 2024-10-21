import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  late double screenWidth;
  late double screenHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;

    tabletWidth = screenWidth * 1; // Adjust the percentages as needed
    landscapeWidth = screenWidth * 1; // Adjust the percentages as needed
  }

  @override
  Widget build(BuildContext context) {
    double width;
    if (screenWidth > 600) {
      width = tabletWidth;
    } else if (MediaQuery.of(context).orientation == Orientation.landscape) {
      width = landscapeWidth;
    } else {
      width = screenWidth * 1.4;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(ROUTE_TICKETLIST),
            icon: const Icon(
              Icons.list,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
        ],
        backgroundColor: primarycolor,
      ),
      body: GetBuilder<PosController>(
        init: posController,
        builder: (controller) {
          final detailList = controller.detailList;
          final totalAmount = controller.calculateTotalAmount();
          return controller.isloading.value
              ? const Center(child: CircularProgressIndicator())
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
                    ),
                  ),
                  Center(
                    child: Obx(() => DropdownButton<String>(
                      value: posController.tableIds.isEmpty ? null : posController.selectedTable.value,
                      onChanged: (String? newValue) {
                        print('Selected Table Document ID: $newValue');
                        posController.selectedTable.value = newValue!;
                        if(newValue == "Select the Table"){
                          posController.detailList.clear();
                          posController.totalamount.value = "0";
                          Fluttertoast.showToast(msg: "Select the Table");
                        }else{
                          posController.fetchTable();
                        }
                      },
                      items: posController.tableIds
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
                  ),
                  _buildDataTable(detailList, width),
                  Text(
                    'Total Amount : $totalAmount RM',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionButtons(controller),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataTable(RxList<forPosTicketDetail> detailList, double width) {
    return Obx(() => SizedBox(
      height: screenHeight * 0.5,
      width: width,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Item Name')),
            DataColumn(label: Text('Per Item')),
            DataColumn(label: Text('Item Quantity')),
            DataColumn(label: Text('Total Value')),
          ],
          rows: detailList.map((item) {
            final controller = Get.find<PosController>();
            return DataRow(
              cells: [
                DataCell(Text(
                  item.name!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                DataCell(Text(
                  '${item.price!} RM',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w100,
                  ),
                )),
                DataCell(
                  SizedBox(
                    width: screenWidth * 0.2,
                    child: Card(
                      elevation: 5,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => controller.decreaseItemCount(item),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Text(item.itemcount!.toString()),
                          SizedBox(width: screenWidth * 0.01),
                          InkWell(
                            onTap: () => controller.increaseItemCount(item),
                            child: const Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                DataCell(Text(
                  '${controller.calculateTotalValue(item).toString()} RM',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            );
          }).toList(),
        ),
      ),
    ));
  }

  Widget _buildActionButtons(PosController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 55,
                  width: 175,
                  child: ElevatedButton(
                    onPressed: controller.clear,
                    style: ElevatedButton.styleFrom(
                      primary: primarycolor,
                    ),
                    child: const Text(
                      "Clear",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: SizedBox(
                  height: 55,
                  width: 175,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 55,
            width: 175,
            child: ElevatedButton(
              onPressed: controller.submitWithoutTime,
              style: ElevatedButton.styleFrom(
                primary: primarycolor,
              ),
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



