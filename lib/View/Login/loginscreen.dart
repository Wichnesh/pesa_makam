import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Controller/logincontroller.dart';
import '../../utils/ImageUtils.dart';
import '../../utils/constant.dart';

class loginscreen extends StatefulWidget {
  const loginscreen({Key? key}) : super(key: key);

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _transform;
  final LoginController _logincontroller = Get.put(LoginController());

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

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          if (isLandscape) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: size.height,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xffD5F069),
                          Color(0xff6FE055),
                        ],
                      ),
                    ),
                    child: Obx(
                      () => Opacity(
                        opacity:
                            _logincontroller.isPasswordEmpty.value ? 0.8 : 1.0,
                        child: Transform.scale(
                          scale: _logincontroller.isPasswordEmpty.value
                              ? 0.98
                              : 1.0,
                          child: Container(
                            width: size.width * .9,
                            height: size.height * .9,
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
                                  height: size.height * .2,
                                  width: size.width * .3,
                                  child: Image.asset(
                                    logo,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(),
                                component1(
                                  Icons.email_outlined,
                                  'Email...',
                                  false,
                                  true,
                                  _logincontroller.emailController,
                                ),
                                _logincontroller.isPasswordEmpty.value
                                    ? component1(
                                        Icons.lock_outline,
                                        'Password...',
                                        true,
                                        false,
                                        _logincontroller.passwordController,
                                        Colors.red,
                                      )
                                    : component1(
                                        Icons.lock_outline,
                                        'Password...',
                                        true,
                                        false,
                                        _logincontroller.passwordController,
                                      ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    component2(
                                      'Sign in',
                                      2.6,
                                      _logincontroller.loginWithEmail,
                                    ),
                                  ],
                                ),
                                SizedBox(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Forgotten Password ? ',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Reset',
                                        style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            if (_logincontroller
                                                .emailController.text.isEmpty) {
                                              Get.snackbar(
                                                  "Error", "Please enter email",
                                                  colorText: Colors.white,
                                                  backgroundColor: Colors.red,
                                                  snackPosition:
                                                      SnackPosition.TOP);
                                            } else {
                                              _onForgotPasswordTapped();
                                            }
                                          },
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     const Text(
                                //       'Don\'t Have an account ? ',
                                //       style: TextStyle(fontSize: 15),
                                //     ),
                                //     RichText(
                                //       text: TextSpan(
                                //         text: 'Register',
                                //         style: const TextStyle(
                                //           color: Colors.blueAccent,
                                //           fontSize: 15,
                                //         ),
                                //         recognizer: TapGestureRecognizer()
                                //           ..onTap = () {
                                //             Get.toNamed(ROUTE_REGISTER);
                                //           },
                                //       ),
                                //     ),
                                //   ],
                                // ),//Register page
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
          } else {
            return ScrollConfiguration(
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
                    child: Obx(
                      () => Opacity(
                        opacity:
                            _logincontroller.isPasswordEmpty.value ? 0.8 : 1.0,
                        child: Transform.scale(
                          scale: _logincontroller.isPasswordEmpty.value
                              ? 0.98
                              : 1.0,
                          child: Container(
                            width: size.width * .9,
                            height: size.width * 1.2,
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
                                  ),
                                ),
                                const SizedBox(),
                                component1(
                                  Icons.email_outlined,
                                  'Email...',
                                  false,
                                  true,
                                  _logincontroller.emailController,
                                ),
                                _logincontroller.isPasswordEmpty.value
                                    ? component1(
                                        Icons.lock_outline,
                                        'Password...',
                                        true,
                                        false,
                                        _logincontroller.passwordController,
                                        Colors.red,
                                      )
                                    : component1(
                                        Icons.lock_outline,
                                        'Password...',
                                        true,
                                        false,
                                        _logincontroller.passwordController,
                                      ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    component2(
                                      'Sign in',
                                      2.6,
                                      _logincontroller.loginWithEmail,
                                    ),
                                  ],
                                ),
                                SizedBox(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Forgotten Password ? ',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Reset',
                                        style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            if (_logincontroller
                                                .emailController.text.isEmpty) {
                                              Get.snackbar(
                                                  "Error", "Please enter email",
                                                  colorText: Colors.white,
                                                  backgroundColor: Colors.red,
                                                  snackPosition:
                                                      SnackPosition.TOP);
                                            } else {
                                              _onForgotPasswordTapped();
                                            }
                                          },
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     const Text(
                                //       'Don\'t Have an account ? ',
                                //       style: TextStyle(fontSize: 15),
                                //     ),
                                //     RichText(
                                //       text: TextSpan(
                                //         text: 'Register',
                                //         style: const TextStyle(
                                //           color: Colors.blueAccent,
                                //           fontSize: 15,
                                //         ),
                                //         recognizer: TapGestureRecognizer()
                                //           ..onTap = () {
                                //             Get.toNamed(ROUTE_REGISTER);
                                //           },
                                //       ),
                                //     ),
                                //   ],
                                // ),//Register page
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
        },
      ),
    );
  }

  // Function to handle "Forgotten Password" tap
  void _onForgotPasswordTapped() {
    _logincontroller.sendPasswordResetLink();
  }

  Widget component1(IconData icon, String hintText, bool isPassword,
      bool isEmail, TextEditingController controller,
      [Color? errorColor]) {
    Size size = MediaQuery.of(Get.context!).size;
    return Container(
      height: size.width / 8,
      width: size.width / 1.22,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: size.width / 30),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black.withOpacity(.8)),
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
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
          errorText: errorColor != null ? 'Password cannot be empty' : null,
          errorStyle: TextStyle(color: errorColor),
        ),
      ),
    );
  }

  Widget component2(String string, double width, VoidCallback voidCallback) {
    Size size = MediaQuery.of(Get.context!).size;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: voidCallback,
      child: Container(
        height: size.width / 10,
        width: size.width / 3.5,
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
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
