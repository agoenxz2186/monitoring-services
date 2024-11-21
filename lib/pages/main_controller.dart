
import 'dart:async';

import 'package:get/get.dart';
import 'package:monitoring_service/helpers/utils.dart';

class MainController extends GetxController{
  RxBool isHealth = false.obs;
  static bool sudahCek = false;

  Future cekKoneksiInternet()async{
      if(sudahCek)return;
      sudahCek = true;
      _startCheck();
  }

  Future _startCheck()async{
    
      isHealth.value = await cekInternet();
      
      // print("cekkoneksi ${isHealth.value}");
      await Future.delayed(const Duration(seconds: 3));
      _startCheck();
  } 

} 