 

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoring_service/helpers/utils.dart';
import 'package:monitoring_service/models/services_model.dart';
import 'package:monitoring_service/pages/main_controller.dart';
import 'package:monitoring_service/pages/monitoring_page/monitoring_controller.dart';
import 'package:monitoring_service/pages/tambahservice_page/tambahservice_page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:quickalert/quickalert.dart';
import 'package:window_manager/window_manager.dart'; 

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(MonitoringController());
    final ctrlmain = Get.find<MainController>();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.check_circle, color: Colors.green,),
        title: Obx( () {
            return ctrlmain.isHealth.value ? const Text('Monitoring Services (Internet Online)') : const Text('Monitoring Services (Internet Offline)');
          }
        ),
        actions: [
          IconButton(onPressed: (){
            ctrl.refreshController.requestRefresh();
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){

        showDialog(context: context, builder: (c)=>const TambahservicePage()).then((e){
            ctrl.refreshController.requestRefresh();
        });
      }, tooltip: "Tambah Monitoring", child: const Icon(Icons.add),) ,
      body: Stack(
        children: [
          Obx( () {
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: SmartRefresher(
                  controller: ctrl.refreshController,
                  onRefresh: ctrl.onRefresh,
                  child: Wrap(
                    children: [
                     
                      for(var n in ctrl.listData)
                      ItemServices(n: n, onRequestRefresh: () {
                          ctrl.refreshController.requestRefresh();
                      },)
                    ],
                  ),
                ),
              );
            }
          ),

          Obx( () {
              return ctrlmain.isHealth.value == false ? Positioned(
                left: (MediaQuery.of(context).size.width / 2) - 100,
                top: MediaQuery.of(context).size.height / 2 - 100,
                child: Container(
                  padding: const EdgeInsets.all(50),
                  decoration:  BoxDecoration(
                    color: Colors.red.withOpacity(.2),
                  ),
                  child: const Text("Internet OffLine", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                ),
              ) : const SizedBox();
            }
          ),

        ],
      ),
    );
  }
}

class ItemServices extends StatefulWidget {
  final VoidCallback? onRequestRefresh;
  const ItemServices({
    super.key,
    required this.n,
    this.onRequestRefresh
  });

  final ServiceModel n;

  @override
  State<ItemServices> createState() => _ItemServicesState();
}

class _ItemServicesState extends State<ItemServices> {
  bool isHealth = false;
  int totalNonHealth = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cekKoneksi();
  }

  Future cekKoneksi()async{
      isHealth = await cekHealth(widget.n.url ?? '');
      if(isHealth){
         totalNonHealth = 0;
      }else{
         totalNonHealth++;
      }
      // print("cekkoneksi item ${widget.n.servicename} $isHealth");
      setState(() {});
      await Future.delayed(const Duration(seconds: 9));
      cekKoneksi();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: isHealth ?  Colors.green : Colors.red,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ]
          ),
          child: DefaultTextStyle(
                style: const TextStyle(color: Colors.white,
                  fontSize: 25
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('${widget.n.servicename}'),
                    Text('${widget.n.url}',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
         
        ),
      
        Positioned(
          right: 0,
          child: PopupMenuButton(itemBuilder: (bc)=>[
            const PopupMenuItem(value: 'hapus',child: Text('Hapus'),),
            const PopupMenuItem(value: 'edit',child: Text('Edit'),),
            const PopupMenuItem(value: 'restart',child: Text('Restart Container'),),
          ], child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                color: Colors.white.withOpacity(.5)
              ),
              child: const Icon(Icons.more_horiz),  
            ), onSelected: (value) {
            if(value == "hapus"){
                QuickAlert.show(context: context, type: QuickAlertType.confirm,
                  title: 'Hapus Service', 
                  text: 'Apakah anda yakin akan menghapus services?',
                  cancelBtnText: 'Batal',
                  confirmBtnText: 'Ok',
                  onCancelBtnTap: () {
                      Get.back();
                  },
                  onConfirmBtnTap: () {
             
                      Get.back();
                      widget.n.delete("id=?", [widget.n.id]).then((e){ 
                        widget.onRequestRefresh?.call();
                      });
                  },
                ).then((e)=>{

                });
            }else if(value == 'edit'){
                showDialog(context: context, builder: (bc)=> TambahservicePage(model: widget.n,)).then((e){
                     widget.onRequestRefresh?.call();
                });
            }else if(value == 'restart'){
                int port = int.tryParse(widget.n.port ?? '') ?? 22;
                restartContainer(widget.n.ipserver ?? '', port, widget.n.username ?? '', widget.n.password ?? '', widget.n.containerName ?? '');
            }
          }, ),
        ),

       
      ],
    );
  }
}
 