import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pesa_makanam_app/Controller/homeController.dart';

import '../../../Controller/AddItemController.dart';
import '../../../utils/colorUtils.dart';

class AddItems extends StatefulWidget {
  const AddItems({Key? key}) : super(key: key);

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  @override
  Widget build(BuildContext context) {
    final Screenheight = MediaQuery.of(context).size.height;
    return GetBuilder<AddItemsController>(
      init: AddItemsController(),
      builder: (_controller) => _controller.isloading.value
          ? Scaffold(
              body: Center(
              child: CircularProgressIndicator(),
            ))
          : Scaffold(
              appBar: AppBar(
                title: const Text('Add Items'),
                backgroundColor: primarycolor,
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    height: Screenheight * 0.8,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: Screenheight * 0.1,
                            child: Image.asset("assets/images/logo.png")),
                        SizedBox(height: Screenheight * 0.01),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          primarycolor), // Set the desired border color
                                ),
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                    fontSize: 14, color: primarycolor),
                              ),
                              onChanged: (val) {
                                _controller.name.value = val;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: Screenheight * 0.01),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          primarycolor), // Set the desired border color
                                ),
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                    fontSize: 14, color: primarycolor),
                              ),
                              onChanged: (val) {
                                _controller.description.value = val;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: Screenheight * 0.01),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 18),
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
                                labelText: 'Price',
                                labelStyle: TextStyle(
                                    fontSize: 14, color: primarycolor),
                              ),
                              onChanged: (val) {
                                _controller.price.value = val;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            child: DropdownButtonFormField(
                              hint: Text(
                                _controller.selectedcategory.value,
                              ),
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 25,
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          primarycolor), // Set the desired border color
                                ),
                                labelText: "Category *",
                                labelStyle: TextStyle(
                                    fontSize: 14, color: primarycolor),
                                border: OutlineInputBorder(),
                              ),
                              items: _controller.categories.map(
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
                                _controller.updateSelectedcategory(val);
                                print(
                                    "val:    ${_controller.selectedcategory.value}");
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.34,
                                child: TextField(
                                  readOnly: true,
                                  // enabled: false,
                                  controller: _controller.fileNameText
                                    ..text = _controller.fileName.value,
                                  style: TextStyle(fontSize: 14),
                                  // controller: controller.textController10,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              primarycolor), // Set the desired border color
                                    ),
                                    labelText: "Photo Capture *",
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  bottomSheet(context, _controller);
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 16,
                                  width:
                                      MediaQuery.of(context).size.width / 7.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(),
                                  ),
                                  child: Icon(Icons.file_upload,
                                      color: primarycolor),
                                ),
                              )
                            ],
                          ),
                        ),
                        _controller.fileName.value != ""
                            ? Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.file(_controller.image!)),
                              )
                            : SizedBox(),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 55,
                                  width: 175,
                                  color: primarycolor,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.pressed)) {
                                            // Change the button color when pressed
                                            return Colors.green;
                                          }
                                          // Return the default button color
                                          return primarycolor;
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      _controller.submitData();
                                    },
                                    child: Container(
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
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  height: 55,
                                  width: 175,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.pressed)) {
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
                                    child: Text('Close'),
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
              ),
            ),
    );
  }

  Future<void> bottomSheet(
      BuildContext context, AddItemsController controller) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 140,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: primarycolor, shape: BoxShape.circle),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        controller.getImage(ImageSource.gallery);
                      },
                      child: Icon(Icons.insert_photo_outlined,
                          size: 40, color: Colors.white),
                    )
                    // onPressed: () {
                    // },
                    // child: Text("PICK FROM GALLERY"),
                    ),
                Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: primarycolor, shape: BoxShape.circle),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        controller.getImage(
                          ImageSource.camera,
                        );
                      },
                      child:
                          Icon(Icons.camera_alt, size: 40, color: Colors.white),
                    )
                    // onPressed: () {
                    // },
                    // child: Text("PICK FROM GALLERY"),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
