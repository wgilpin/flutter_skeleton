import 'package:bookings/src/views/map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'src/controllers/bindings/app_binding.dart';
import 'src/theme.dart';
import 'src/views/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // set emulator ports if necessary
  if (const String.fromEnvironment('EMULATOR') == 'true') {
    try {
      debugPrint('Using local Firestore emulator');
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      debugPrint('Failed to use local Firestore emulator: $e');
      // ignore: avoid_print
      print(e);
    }
  } else {
    debugPrint('Using remote Firestore');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'What Next',
        initialBinding: AppBindings(),
        theme: makeTheme(),
        scrollBehavior: MyCustomScrollBehavior(),
        home: Root());
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
