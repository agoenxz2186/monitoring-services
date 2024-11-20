import 'package:flutter/material.dart';
import 'package:monitoring_service/pages/tambahservice_page/tambahservice_page.dart';
import 'package:window_manager/window_manager.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Services'),
      
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showDialog(context: context, builder: (c)=>TambahservicePage()).then((e){

        });
      }, tooltip: "Tambah Monitoring", child: Icon(Icons.add),) ,
      body: const SingleChildScrollView(
        child: Wrap(
          children: [

          ],
        ),
      ),
    );
  }
}