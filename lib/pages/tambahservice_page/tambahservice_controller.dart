
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:monitoring_service/helpers/utils.dart';
import 'package:monitoring_service/models/services_model.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

extension StreamUint8ListExtension on Stream<Uint8List> {
  Stream<String> toUtf8String() {
    return transform(
      StreamTransformer<Uint8List, String>.fromHandlers(
        handleData: (data, sink) {
          sink.add(utf8.decode(data));
        },
      ),
    );
  }
}

class TambahserviceController extends GetxController{
   GlobalKey<FormState> formKey = GlobalKey<FormState>();
   TextEditingController txtAlamatURL = TextEditingController();
   TextEditingController txtNamaService = TextEditingController();
   TextEditingController txtKeterangan = TextEditingController();
   TextEditingController txtAlamatIPServer = TextEditingController();
   TextEditingController txtPortServer = TextEditingController();
   TextEditingController txtUserName = TextEditingController();
   TextEditingController txtPassword = TextEditingController();
   TextEditingController txtContainerName = TextEditingController();
   RxBool loading = false.obs;
   RxBool testResult = false.obs;
   ServiceModel? _model;

   Future showData(ServiceModel? model)async{

      _model = model;
      txtAlamatURL.text = model?.url ?? "";
      txtNamaService.text = model?.servicename ?? "";
      txtKeterangan.text = model?.description ?? "";
      txtAlamatIPServer.text = model?.ipserver ?? "";
      txtPortServer.text = model?.port ?? "";
      txtUserName.text = model?.username ?? "";
      txtPassword.text = model?.password ?? "";
      txtContainerName.text = model?.containerName ?? "";
      refresh();
   }

   void newData(){
      _model = null;
      txtAlamatURL.text = "";
      txtNamaService.text = "";
      txtKeterangan.text = "";
      txtAlamatIPServer.text = "";
      txtPortServer.text = "";
      txtUserName.text = "";
      txtPassword.text = "";
      txtContainerName.text = "";
   }

   Future<bool> testConnection()async{
      final testssh = await testSSH();
      final testurl = await testAlamatURL();

      if(testssh == false){
           await QuickAlert.show(context: Get.context!, type: QuickAlertType.warning,
              title: 'Tes Koneksi',
              text: 'Koneksi SSH ke ${txtAlamatIPServer.value.text} gagal'
            );
      }

      if(testurl == false){
           QuickAlert.show(context: Get.context!, type: QuickAlertType.warning,
              title: 'Tes Koneksi',
              text: 'Koneksi URL Server ${txtAlamatURL.value.text} gagal'
            );
      }
      return testssh && testurl;
   }

   Future<bool> testAlamatURL()async{
      final url = Uri.parse(txtAlamatURL.value.text);
      final r = await http.get(url).timeout(Duration(seconds: 4));
      if(r.statusCode == 200){
        return true;
      }
      return false;
   }

   Future<bool> testSSH()async{
      int port = int.tryParse(txtPortServer.value.text) ?? 22;
      String serveraddres = txtAlamatIPServer.value.text;
      String username = txtUserName.value.text;
      String pass = txtPassword.value.text;

      loading.value = true;
      testResult.value = false;
      try{
          final socket = await SSHSocket.connect(txtAlamatIPServer.value.text, port, timeout: Duration(seconds: 10));
          // print("login ssh : $serveraddres:$port = $username:$pass");
          final client = SSHClient(socket, username: username,
            onPasswordRequest: () {
              return pass;
            },
          );
          final shell = await client.shell();
          shell.write( stringToUint8List('ls') ); 
          shell.stdout.listen((out){
            print(utf8.decode(out)); 
          });
          shell.close();
          testResult.value = true;
      }catch(e){
          print("Terjadi erro $e");
      }
      loading.value = false;
      return testResult.value;
   }

   Future<bool> simpan()async{
      loading.value = true;

      final service = ServiceModel(
        id: _model?.id ?? 0,
        url: txtAlamatURL.value.text,
        servicename: txtNamaService.value.text,
        description: txtKeterangan.value.text,
        ipserver: txtAlamatIPServer.value.text,
        port: txtPortServer.value.text,
        username: txtUserName.value.text,
        password: txtPassword.value.text,
        containerName: txtContainerName.value.text,
        createdAt: DateTime.now().toString(),
      );
  
      int r = 0;
      if(_model == null){ 
        r = await service.insert( service.toMap() ) ?? 0;
      }else{
        r = await service.update(service.toMap(),
          where: "id=?", whereArgs: [_model!.id]
        );
      }
      loading.value = false;

      return r > 0;
   }
}