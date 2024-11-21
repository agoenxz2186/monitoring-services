import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoring_service/helpers/encryption_services.dart';
import 'package:monitoring_service/pages/main_controller.dart';
import 'package:monitoring_service/pages/monitoring_page/monitoring_page.dart';
import 'package:window_manager/window_manager.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String plaintext = "halo ini test";
  String password = "abcdef";
  String enk = EncryptionService.encrypt(plaintext, password);
  String dec = EncryptionService.decrypt(enk, password);
  print("plaintext: $plaintext, enkripsi: $enk, dekripsi: $dec");
  
  
  if(Platform.isWindows || Platform.isLinux || Platform.isMacOS){
 
     await WindowManager.instance.ensureInitialized();
     WindowOptions options = const WindowOptions(
      size: Size(1024, 768),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false
     );
     windowManager.waitUntilReadyToShow(options, () async {
        // await windowManager.setFullScreen(true);
        await windowManager.show();
        await windowManager.focus();
        await windowManager.maximize();
        windowManager.setTitle("Monitoring Service");
     });
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(MainController());
    ctrl.cekKoneksiInternet();

    return GetMaterialApp(
      title: "Monitoring Service",
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromARGB(255, 77, 76, 76)),
            gapPadding: 1
          )
        )
      ),
      home: const MonitoringPage(),
    );
  }
}