import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false
    ..toastPosition = EasyLoadingToastPosition.bottom
    ..animationStyle = EasyLoadingAnimationStyle.offset;
}

void showToast(String? message) {
  message ??= 'Somthing went wrong. Please try again.';
  EasyLoading.instance
    ..radius = 100.0
    ..maskType = EasyLoadingMaskType.none
    ..userInteractions = true
    ..contentPadding = const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 10.0,
    );
  EasyLoading.showToast(
    message,
    toastPosition: EasyLoadingToastPosition.bottom,
  );
  Future.delayed(const Duration(seconds: 3), () {
    configLoading();
  });
}
