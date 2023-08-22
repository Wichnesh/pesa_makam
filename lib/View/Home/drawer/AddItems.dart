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
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final Screenheight = MediaQuery.of(context).size.height;
    return GetBuilder<AddItemsController>(
      init: AddItemsController(),
      builder: (controller) => controller.isloading.value
          ? const Scaffold(
              body: Center(
              child: CircularProgressIndicator(),
            ))
          : Scaffold(
              appBar: AppBar(
                title: const Text('Add Items'),
                backgroundColor: primarycolor,
              ),
              body: LayoutBuilder(
                builder: (context, constraint) {
                  if (isLandscape) {
                    return SingleChildScrollView(
                      child: Center(
                        child: Container(
                          height: Screenheight * 1.8,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: Screenheight * 0.1,
                                  child: Image.asset("assets/images/logo.png")),
                              SizedBox(height: Screenheight * 0.01),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 50,
                                  width: double.infinity,
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
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                          fontSize: 14, color: primarycolor),
                                    ),
                                    onChanged: (val) {
                                      controller.name.value = val;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: Screenheight * 0.01),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 50,
                                  width: double.infinity,
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
                                      labelText: 'Description',
                                      labelStyle: TextStyle(
                                          fontSize: 14, color: primarycolor),
                                    ),
                                    onChanged: (val) {
                                      controller.description.value = val;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: Screenheight * 0.01),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
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
                                      labelText: 'Price',
                                      labelStyle: TextStyle(
                                          fontSize: 14, color: primarycolor),
                                    ),
                                    onChanged: (val) {
                                      controller.price.value = val;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 60,
                                  width: double.infinity,
                                  child: DropdownButtonFormField(
                                    hint: Text(
                                      controller.selectedcategory.value,
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
                                      labelText: "Category *",
                                      labelStyle: TextStyle(
                                          fontSize: 14, color: primarycolor),
                                      border: OutlineInputBorder(),
                                    ),
                                    items: controller.categories.map(
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
                                      controller.updateSelectedcategory(val);
                                      print(
                                          "val:    ${controller.selectedcategory.value}");
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.34,
                                      child: TextField(
                                        readOnly: true,
                                        // enabled: false,
                                        controller: controller.fileNameText
                                          ..text = controller.fileName.value,
                                        style: const TextStyle(fontSize: 14),
                                        // controller: controller.textController10,
                                        decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    primarycolor), // Set the desired border color
                                          ),
                                          labelText: "Photo Capture *",
                                          labelStyle: TextStyle(
                                              fontSize: 14,
                                              color: primarycolor),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        bottomSheet(context, controller);
                                      },
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                8,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                7.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(),
                                        ),
                                        child: const Icon(Icons.file_upload,
                                            color: primarycolor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              controller.fileName.value != ""
                                  ? Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.file(controller.image!)),
                                    )
                                  : const SizedBox(),
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
                                                MaterialStateProperty
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
                                            controller.submitData();
                                          },
                                          child: const SizedBox(
                                            height: 50,
                                            width: 165,
                                            child: Center(
                                              child: Text(
                                                "Submit",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                                MaterialStateProperty
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
                                          child: const Text('Close'),
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
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Center(
                        child: Container(
                          height: Screenheight * 0.95,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: Screenheight * 0.1,
                                  child: Image.asset("assets/images/logo.png")),
                              SizedBox(height: Screenheight * 0.01),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 50,
                                  width: double.infinity,
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
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                          fontSize: 14, color: primarycolor),
                                    ),
                                    onChanged: (val) {
                                      controller.name.value = val;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: Screenheight * 0.01),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 50,
                                  width: double.infinity,
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
                                      labelText: 'Description',
                                      labelStyle: TextStyle(
                                          fontSize: 14, color: primarycolor),
                                    ),
                                    onChanged: (val) {
                                      controller.description.value = val;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: Screenheight * 0.01),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
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
                                      labelText: 'Price',
                                      labelStyle: TextStyle(
                                          fontSize: 14, color: primarycolor),
                                    ),
                                    onChanged: (val) {
                                      controller.price.value = val;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 55,
                                  width: double.infinity,
                                  child: DropdownButtonFormField(
                                    hint: Text(
                                      controller.selectedcategory.value,
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
                                      labelText: "Category *",
                                      labelStyle: TextStyle(
                                          fontSize: 14, color: primarycolor),
                                      border: OutlineInputBorder(),
                                    ),
                                    items: controller.categories.map(
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
                                      controller.updateSelectedcategory(val);
                                      print(
                                          "val:    ${controller.selectedcategory.value}");
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.34,
                                      child: TextField(
                                        readOnly: true,
                                        // enabled: false,
                                        controller: controller.fileNameText
                                          ..text = controller.fileName.value,
                                        style: const TextStyle(fontSize: 14),
                                        // controller: controller.textController10,
                                        decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    primarycolor), // Set the desired border color
                                          ),
                                          labelText: "Photo Capture *",
                                          labelStyle: TextStyle(
                                              fontSize: 14,
                                              color: primarycolor),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        bottomSheet(context, controller);
                                      },
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                16,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                7.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(),
                                        ),
                                        child: const Icon(Icons.file_upload,
                                            color: primarycolor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              controller.fileName.value != ""
                                  ? Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.file(controller.image!)),
                                    )
                                  : const SizedBox(),
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
                                                MaterialStateProperty
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
                                            controller.submitData();
                                          },
                                          child: const SizedBox(
                                            height: 50,
                                            width: 165,
                                            child: Center(
                                              child: Text(
                                                "Submit",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                                MaterialStateProperty
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
                                          child: const Text('Close'),
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
                    );
                  }
                },
              )),
    );
  }

  Future<void> bottomSheet(
      BuildContext context, AddItemsController controller) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 140,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                        color: primarycolor, shape: BoxShape.circle),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        controller.getImage(ImageSource.gallery);
                      },
                      child: const Icon(Icons.insert_photo_outlined,
                          size: 40, color: Colors.white),
                    )
                    // onPressed: () {
                    // },
                    // child: Text("PICK FROM GALLERY"),
                    ),
                Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                        color: primarycolor, shape: BoxShape.circle),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        controller.getImage(
                          ImageSource.camera,
                        );
                      },
                      child: const Icon(Icons.camera_alt,
                          size: 40, color: Colors.white),
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
