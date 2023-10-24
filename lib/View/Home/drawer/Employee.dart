import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pesa_makanam_app/Controller/EmployeeController.dart';
import 'package:pesa_makanam_app/utils/colorUtils.dart';
import 'package:get/get.dart';

class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  final EmployeeController _employeeController = Get.put(EmployeeController());
  @override
  Widget build(BuildContext context) {
    final Screenheight = MediaQuery.of(context).size.height;
    final Screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee'),
        backgroundColor: primarycolor,
      ),
      body: GetBuilder<EmployeeController>(
        init: EmployeeController(),
        builder: ((controller) {
          if (controller.isloading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: Screenheight * 1.8,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: Screenheight * 0.1,
                          child: Image.asset("assets/images/logo.png")),
                      SizedBox(
                        height: Screenheight * 0.01,
                      ),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.transparent,
                        backgroundImage: controller.image.value != null
                            ? FileImage(controller.image.value!)
                            : null,
                        child: controller.image.value == null
                            ? const Icon(Icons.image, size: 100)
                            : null,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                // Change the button color when pressed
                                return Colors.green;
                              }
                              // Return the default button color
                              return primarycolor;
                            },
                          ),
                        ),
                        onPressed: () =>
                            bottomSheet(context,controller),
                        child: const Text('Select Image'),
                      ),
                      SizedBox(height: Screenheight * 0.01),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
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
                                    labelText: 'Name *',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.name.value = val;
                                    controller.update();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Screenwidth * 0.04,
                            ),
                            Expanded(
                              child: SizedBox(
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
                                    labelText: 'Employee Id *',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.employeeId.value = val;
                                    controller.update();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //Name
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                width: double.infinity,
                                child: DropdownButtonFormField(
                                  hint: Text(
                                    controller.selectedSex.value,
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
                                    labelText: "Sex *",
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: controller.sex.map(
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
                                    controller.updateSex(val);
                                    print(
                                        "val:    ${controller.selectedSex.value}");
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Screenwidth * 0.04,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                width: 165,
                                child: TextField(
                                  readOnly: true,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    DateTime? date = DateTime.now();

                                    date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now());
                                    controller.DOB = date;
                                    controller.DOBText.value =
                                        DateFormat("yyyy-MM-dd").format(date!);
                                    controller.update();
                                  },
                                  controller: controller.DOBTextField
                                    ..text = controller.DOBText.value,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.calendar_today),
                                    labelText: "Date of Birth *",
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //Sex
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: Screenheight * 0.068,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              primarycolor), // Set the desired border color
                                    ),
                                    labelText: 'Age *',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.age.value = val;
                                    controller.update();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Screenwidth * 0.04,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                width: 165,
                                child: TextField(
                                  readOnly: true,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    DateTime? date = DateTime.now();

                                    date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now());
                                    controller.DOJ = date;
                                    controller.DOJText.value =
                                        DateFormat("yyyy-MM-dd").format(date!);
                                    controller.update();
                                  },
                                  controller: controller.DOJTextField
                                    ..text = controller.DOJText.value,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.calendar_today),
                                    labelText: "Date of Joining*",
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //Age
                      Padding(
                        padding: const EdgeInsets.all(10.00),
                        child: SizedBox(
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
                              labelText: 'Nationality *',
                              labelStyle:
                                  TextStyle(fontSize: 14, color: primarycolor),
                            ),
                            onChanged: (val) {
                              controller.nationality.value = val;
                              controller.update();
                            },
                          ),
                        ),
                      ), //Nationality
                      Padding(
                        padding: const EdgeInsets.all(10.00),
                          child: SizedBox(
                            height: Screenheight / 10,
                            child: TextField(
                              maxLines: 3,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                        primarycolor), // Set the desired border color
                                  ),
                                  labelText: 'Address *',
                                  labelStyle: TextStyle(
                                      fontSize: 14, color: primarycolor),
                                  hintText: 'enter......',
                                  border: OutlineInputBorder()),
                              onChanged: (val) {
                                controller.permanentaddress.value = val;
                                setState(() {});
                              },
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.34,
                              child: TextField(
                                readOnly: true,
                                // enabled: false,
                                controller: controller.addressNameText
                                  ..text = controller.addressproofName.value,
                                style: const TextStyle(fontSize: 14),
                                // controller: controller.textController10,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            primarycolor), // Set the desired border color
                                  ),
                                  labelText: "Address proof Attachment",
                                  labelStyle: TextStyle(
                                      fontSize: 14, color: primarycolor),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                AddressproofbottomSheet(context, controller);
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 16,
                                width: MediaQuery.of(context).size.width / 7.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(),
                                ),
                                child: const Icon(Icons.file_upload,
                                    color: primarycolor),
                              ),
                            )
                          ],
                        ),
                      ), //Address proof Attachment
                      controller.addressproofName.value != ""
                          ? Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                  height: Screenheight * 0.1,
                                  width: Screenwidth * 0.3,
                                  child: Image.file(
                                      controller.addressproofimage!)),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: Screenheight * 0.068,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              primarycolor), // Set the desired border color
                                    ),
                                    labelText: 'Phone number',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.phonenumber.value = val;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Screenwidth * 0.04,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: Screenheight * 0.068,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              primarycolor), // Set the desired border color
                                    ),
                                    labelText: 'Alternate Phone number',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.alternatephonenumber.value = val;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //Phone number
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
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
                                    labelText: 'Emergency contact name',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.emergencycontactname.value = val;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Screenwidth * 0.04,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: Screenheight * 0.068,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              primarycolor), // Set the desired border color
                                    ),
                                    labelText: 'Emergency contact Phone number',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.emergencycontactnumber.value =
                                        val;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //Emergency contact
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
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
                                    labelText: 'Passport No',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.passportno.value = val;
                                    controller.update();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Screenwidth * 0.04,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                width: 165,
                                child: TextField(
                                  readOnly: true,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    DateTime? date = DateTime.now();

                                    date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now());
                                    controller.Expiry = date;
                                    controller.expiryText.value =
                                        DateFormat("yyyy-MM-dd").format(date!);
                                    controller.update();
                                  },
                                  controller: controller.expiryTextField
                                    ..text = controller.expiryText.value,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.calendar_today),
                                    labelText: "Expiry Date",
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //passport no //
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.34,
                              child: TextField(
                                readOnly: true,
                                // enabled: false,
                                controller: controller.passportNameText
                                  ..text = controller.passportName.value,
                                style: const TextStyle(fontSize: 14),
                                // controller: controller.textController10,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            primarycolor), // Set the desired border color
                                  ),
                                  labelText: "Passport Attachment",
                                  labelStyle: TextStyle(
                                      fontSize: 14, color: primarycolor),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                passportbottomSheet(context, controller);
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 16,
                                width: MediaQuery.of(context).size.width / 7.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(),
                                ),
                                child: const Icon(Icons.file_upload,
                                    color: primarycolor),
                              ),
                            )
                          ],
                        ),
                      ), //passport Attachment
                      controller.passportName.value != ""
                          ? Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                  height: Screenheight * 0.1,
                                  width: Screenwidth * 0.3,
                                  child: Image.file(controller.passportimage!)),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
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
                                    labelText: 'Role *',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.roles.value = val;
                                    controller.update();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Screenwidth * 0.04,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: Screenheight * 0.068,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: primarycolor,
                                      ),
                                    ),
                                    labelText: 'Per day wages *',
                                    labelStyle: TextStyle(
                                      fontSize: 14,
                                      color: primarycolor,
                                    ),
                                    suffixText: 'RM',
                                    suffixStyle: TextStyle(
                                        fontSize: 18, color: primarycolor),
                                  ),
                                  onChanged: (val) {
                                    controller.perdaywages.value = val;
                                    controller.update();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          // Change the button color when pressed
                                          return Colors.green;
                                        }
                                        // Return the default button color
                                        return primarycolor;
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.submit();
                                  },
                                  child: const SizedBox(
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
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                width: 175,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
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
        }),
      ),
    );
  }

  Future<void> bottomSheet(
      BuildContext context, EmployeeController controller) {
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

  Future<void> passportbottomSheet(
      BuildContext context, EmployeeController controller) {
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
                        controller.passportImage(ImageSource.gallery);
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

  Future<void> governmentidbottomSheet(
      BuildContext context, EmployeeController controller) {
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
                        controller.GovernmentIdImage(ImageSource.gallery);
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

  Future<void> AddressproofbottomSheet(
      BuildContext context, EmployeeController controller) {
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
                        controller.AddressproofImage(ImageSource.gallery);
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
