import 'package:bookings/src/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import 'login/login_page.dart';

class Root extends GetWidget<AuthCtl> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.user == null) {
        return LoginPage();
      } else {
        return HomePage();
      }
    });
  }
}
