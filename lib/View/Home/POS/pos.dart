import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pesa_makanam_app/utils/colorUtils.dart';

import '../../../Controller/PosController.dart';

class Pos_screen extends StatefulWidget {
  const Pos_screen({Key? key}) : super(key: key);

  @override
  State<Pos_screen> createState() => _Pos_screenState();
}

class _Pos_screenState extends State<Pos_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
        backgroundColor: primarycolor,
      ),
      body: GetBuilder<PosController>(
          init: PosController(),
          builder: ((_controller) => _controller.isloading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        child: Expanded(
                            child: ListView.builder(
                                itemCount: _controller.detailList.length,
                                itemBuilder: (context, index) {
                                  if (index >= _controller.detailList.length) {
                                    return Container();
                                  } else {
                                    return ListTile(
                                      title: Text(
                                          _controller.detailList[index].name!),
                                    );
                                  }
                                })),
                      )
                    ],
                  ),
                ))),
    );
  }
}
