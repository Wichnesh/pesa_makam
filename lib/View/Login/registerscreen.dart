import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Controller/registerController.dart';
import '../../utils/ImageUtils.dart';
import '../../utils/colorUtils.dart';
import '../../utils/constant.dart';
import 'loginscreen.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({Key? key}) : super(key: key);

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen>
    with SingleTickerProviderStateMixin {
  final RegisterController _registerController =
      Get.put(RegisterController()); // Initialize the controller
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _transform;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });
    _transform = Tween<double>(begin: 2, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _selectedUserType;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffD5F069),
                    Color(0xff6FE055),
                  ],
                ),
              ),
              child: Opacity(
                opacity: _opacity.value,
                child: Transform.scale(
                  scale: _transform.value,
                  child: Container(
                    width: size.width * .9,
                    height: size.width * 1.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 90,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(),
                        Container(
                            height: size.height * .15,
                            width: size.width * .4,
                            child: Image.asset(
                              logo,
                              fit: BoxFit.fill,
                            )),
                        SizedBox(),
                        Name(Icons.person, 'Name...'),
                        Email(
                          Icons.email_outlined,
                          'Email...',
                        ),
                        password(Icons.lock_outline, 'Password...', true),
                        repassword(
                            Icons.lock_outline, 're-enter Password...', true),
                        UserTypeDropdown(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            component2(
                              'Register',
                              2.6,
                              () {
                                HapticFeedback.lightImpact();
                                _registerController.registeruser();
                              },
                            ),
                          ],
                        ),
                        SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already registered ?',
                              style: TextStyle(fontSize: 15),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Sign-in',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 15,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.back();
                                  },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget Email(IconData icon, String hintText) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => Container(
        height: size.width / 8,
        width: size.width / 1.22,
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: size.width / 30),
        decoration: BoxDecoration(
          color: _registerController.emailErrorText.value.isNotEmpty
              ? Colors.red.withOpacity(.2)
              : Colors.black.withOpacity(.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _registerController.emailController,
          onChanged: (value) => _registerController.validateEmail(),
          style: TextStyle(color: Colors.black.withOpacity(.8)),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.black.withOpacity(.7),
            ),
            border: InputBorder.none,
            hintMaxLines: 1,
            hintText: hintText,
            hintStyle:
                TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
            errorText: _registerController.emailErrorText.value.isNotEmpty
                ? _registerController.emailErrorText.value
                : null,
          ),
        ),
      ),
    );
  }

  Widget Name(IconData icon, String hintText) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => Container(
        height: size.width / 8,
        width: size.width / 1.22,
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: size.width / 30),
        decoration: BoxDecoration(
          color: _registerController.nameErrorText.value.isNotEmpty
              ? Colors.red.withOpacity(.2)
              : Colors.black.withOpacity(.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _registerController.nameController,
          onChanged: (value) => _registerController.validateName(),
          style: TextStyle(color: Colors.black.withOpacity(.8)),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.black.withOpacity(.7),
            ),
            border: InputBorder.none,
            hintMaxLines: 1,
            hintText: hintText,
            hintStyle:
                TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
            errorText: _registerController.nameErrorText.value.isNotEmpty
                ? _registerController.nameErrorText.value
                : null,
          ),
        ),
      ),
    );
  }

  Widget component2(String string, double width, VoidCallback voidCallback) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: voidCallback,
      child: Container(
        height: size.width / 8,
        width: size.width / width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xff8abe53),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          string,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget password(IconData icon, String hintText, bool isPassword) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => Container(
        height: size.width / 8,
        width: size.width / 1.22,
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: size.width / 30),
        decoration: BoxDecoration(
          color: _registerController.passwordErrorText.value.isNotEmpty
              ? Colors.red.withOpacity(.2)
              : Colors.black.withOpacity(.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _registerController.passwordController,
          onChanged: (value) => _registerController.validatePassword(),
          style: TextStyle(color: Colors.black.withOpacity(.8)),
          obscureText: isPassword,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.black.withOpacity(.7),
            ),
            border: InputBorder.none,
            hintMaxLines: 1,
            hintText: hintText,
            hintStyle:
                TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
            errorText: _registerController.passwordErrorText.value.isNotEmpty
                ? _registerController.passwordErrorText.value
                : null,
          ),
        ),
      ),
    );
  }

  Widget repassword(IconData icon, String hintText, bool isPassword) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => Container(
        height: size.width / 8,
        width: size.width / 1.22,
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: size.width / 30),
        decoration: BoxDecoration(
          color: _registerController.rePasswordErrorText.value.isNotEmpty
              ? Colors.red.withOpacity(.2)
              : Colors.black.withOpacity(.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _registerController.rePasswordController,
          onChanged: (value) => _registerController.validateRePassword(),
          style: TextStyle(color: Colors.black.withOpacity(.8)),
          obscureText: isPassword,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.black.withOpacity(.7),
            ),
            border: InputBorder.none,
            hintMaxLines: 1,
            hintText: hintText,
            hintStyle:
                TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
            errorText: _registerController.rePasswordErrorText.value.isNotEmpty
                ? _registerController.rePasswordErrorText.value
                : null,
          ),
        ),
      ),
    );
  }

  Widget UserTypeDropdown() {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => Container(
        height: size.width / 8,
        width: size.width / 1.22,
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: size.width / 30),
        decoration: BoxDecoration(
          color: _registerController.userTypeErrorText.value.isNotEmpty
              ? Colors.red.withOpacity(.2)
              : Colors.black.withOpacity(.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _registerController.userType.value,
            onChanged: (String? value) {
              _registerController.userType.value = value!;
              _registerController.validateUserType();
            },
            items: _registerController.roles
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            style: TextStyle(color: Colors.black.withOpacity(.8)),
            hint: Text(
              'Select a role',
              style:
                  TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
            ),
          ),
        ),
      ),
    );
  }
}
