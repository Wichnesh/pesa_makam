import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pesa_makanam_app/utils/colorUtils.dart';
import 'package:pinput/pinput.dart';
import '../../../Controller/AdminAccessController.dart';

class AdminAccessScreen extends GetView<AdminAccessController> {
  const AdminAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Access"),
        centerTitle: true,
        backgroundColor: primarycolor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PinputExample(),
          ],
        ),
      ),
    );
  }
}




/// This is the basic usage of Pinput
/// For more examples check out the demo directory
class PinputExample extends StatefulWidget {
  const PinputExample({Key? key}) : super(key: key);

  @override
  State<PinputExample> createState() => _PinputExampleState();
}

class _PinputExampleState extends State<PinputExample> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  final controller = Get.find<AdminAccessController>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const focusedBorderColor = primarycolor;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = primarycolor;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.admin_panel_settings_outlined,size: screenHeight / 8,color: primarycolor,),
          SizedBox(height: screenHeight/12,),
          Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            child: Pinput(
              controller: pinController,
              focusNode: focusNode,
              length: 6,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 8),
              validator: (value) {
                if (controller.password.value == "$value") {
                  return null;
                } else {
                  return 'Pin is incorrect';
                }
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          SizedBox(height: screenHeight/12,),
          Obx(() => controller.adminAccess.value ?
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty
                  .resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(
                      MaterialState.pressed)) {
                    // Change the button color when pressed
                    return Colors.red;
                  }
                  // Return the default button color
                  return Colors
                      .green; // or any other color you want
                },
              ),
            ),
            onPressed: () {
              focusNode.unfocus();
              formKey.currentState!.validate();
              // Check if the entered pin matches the controller's password
              if (controller.password.value == pinController.text) {
                print('Entered Pin: ${pinController.text}');
                controller.updateAdminAccess();
              } else {
                print('Pin is incorrect');
              }
            },
            child: const Text('Revoke Access'),
          ) :
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty
                  .resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(
                      MaterialState.pressed)) {
                    // Change the button color when pressed
                    return Colors.red;
                  }
                  // Return the default button color
                  return Colors
                      .green; // or any other color you want
                },
              ),
            ),
            onPressed: () {
              focusNode.unfocus();
              formKey.currentState!.validate();
              // Check if the entered pin matches the controller's password
              if (controller.password.value == pinController.text) {
                print('Entered Pin: ${pinController.text}');
                controller.updateAdminAccess();
              } else {
                print('Pin is incorrect');
              }
            },
            child: const Text('Access'),
          ),)
        ],
      ),
    );
  }
}