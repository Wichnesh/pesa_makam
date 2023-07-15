import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/ImageUtils.dart';
import '../utils/colorUtils.dart';
import '../utils/constant.dart';
import '../utils/pref_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Animation? _logoAnimation;
  AnimationController? _logoAnimationController;
  SharedPreferences? _prefs;
  bool _isLoggedIn = false;
  bool _initialized = false;
  bool _error = false;
  String? errorMsg;
  @override
  void initState() {
    super.initState();

    _logoAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _logoAnimation = Tween(begin: 0.0, end: 200.0).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _logoAnimationController!));

    _logoAnimationController!.addStatusListener((AnimationStatus status) {});
    _logoAnimationController!.forward();

    initializeFlutterFire();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        print(' FIRE BASE INIT = ENABLE');
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        print('ERROR $e');
        //errorMsg = e;
        _error = true;
      });
    }
  }

  void navigationPage() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = _prefs!.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn) {
      Get.offAllNamed(ROUTE_HOME);
    } else {
      Get.offAllNamed(ROUTE_LOGIN);
    }
  }

  @override
  void dispose() {
    super.dispose();
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _logoAnimationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: logocolor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            secondChild(),

            // companyName(size)
          ],
        ),
      ),
    );
  }

  Widget secondChild() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final portraitHeight = screenHeight * 0.3;
    final portraitWidth = screenHeight * 0.4;
    final landscapeHeight = screenHeight * 0.4;
    final landscapeWidth = screenWidth * 0.4;

    return AnimatedBuilder(
      animation: _logoAnimationController!,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.only(left: 30, right: 20, bottom: 5),
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? portraitWidth
              : landscapeWidth,
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? portraitHeight
              : landscapeHeight,
          child: Center(
            child: Image.asset(
              splashBg,
              width: double.infinity,
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? portraitHeight
                  : landscapeHeight,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
    );
  }
}
