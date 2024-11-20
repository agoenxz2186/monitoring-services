
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:monitoring_service/helpers/utils.dart';

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

   Future<bool> testConnection()async{
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
}