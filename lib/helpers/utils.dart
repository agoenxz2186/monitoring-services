import 'dart:convert';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

Uint8List stringToUint8List(String str) {
  return Uint8List.fromList(utf8.encode('$str\n'));
}

Future<bool> cekHealth(String url)async{
    if(url.trim() == "")return false;
    
    try{
      final uri = Uri.parse(url);
      final r = await http.get(uri).timeout(const Duration(seconds: 5));
      return r.statusCode == 200;
    }catch(e){}
    return false;
}

Future<bool> cekHealthSSH(String server, int port, String username, String password)async{
    try{
     
      final client = await connectSSH(server, port, username, password);
      if(client == null)return false;
      final shell = await client.shell();

      shell.stdout.listen((out){
        print(utf8.decode(out)); 
      });

      shell.write( stringToUint8List('ls') ); 
      shell.close();
      return true;
    }catch(e){
        print("Terjadi erro $e");
    }
    return false;
}

Future<SSHClient?> connectSSH(String server, int port, String username, String password)async{
    try{
      final socket = await SSHSocket.connect(server, port, timeout: const Duration(seconds: 5));
      final client = SSHClient(socket, username: username,
        onPasswordRequest: () {
          return password;
        },
      );
     
    return client;
    }catch(e){
        print("Terjadi erro $e");
    }
    return null;
}

Future restartContainer(String server, int port, String username, String password, String containername)async{
    final listcontainer = containername.split(',');  
    final client = await connectSSH(server, port, username, password);
    if(client == null)return false;

    try{
      final shell = await client.shell();
      shell.stdout.listen((out){
        print(utf8.decode(out));
      });
      for(var n in listcontainer){
        final result = await client.run( 'docker container restart $n' ); 
        final str = utf8.decode(result);
        print("isi str = $str");
        await Future.delayed(const Duration(seconds: 1));
      }      
      await Future.delayed(const Duration(seconds: 10));
      shell.close();
      client.close();
      return true;
    }catch(e){}
    return false;
}

Future cekInternet()async{
    try{ 
      final socket = await Socket.connect('8.8.8.8', 53, timeout: const Duration(seconds: 4));
 
      socket.destroy();
      return true;
    }catch(e){}
    return false;
}