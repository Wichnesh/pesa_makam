import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/PosController.dart';
import '../../../utils/colorUtils.dart';

class TicketList extends StatefulWidget {
  const TicketList({Key? key}) : super(key: key);

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  final PosController posController = Get.put(PosController());
  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: ListView.builder(
                itemCount: posController.savedBills.length,
                itemBuilder: (context, index) {
                  final bill = posController.savedBills[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                            'Date: ${bill.date.split('-').sublist(0, 3).join('-')}'),
                        subtitle: Text('Total Amount: ${bill.totalAmount} RM'),
                        // Display items here
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
