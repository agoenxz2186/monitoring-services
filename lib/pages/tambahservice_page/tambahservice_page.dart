import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:monitoring_service/input_formatter/urlinputformatter.dart';
import 'package:monitoring_service/models/services_model.dart';
import 'package:monitoring_service/pages/tambahservice_page/tambahservice_controller.dart';
import 'package:quickalert/quickalert.dart';

class TambahservicePage extends StatelessWidget {
  final ServiceModel? model;
  const TambahservicePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(TambahserviceController());

    if(model == null){
      ctrl.newData();
    }else{
      ctrl.showData(model ?? ServiceModel());
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      
      child: Stack(
        children: [
          Obx( () {
              return Container(
                width: MediaQuery.of(context).size.width * 0.5,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  const Text('Alamat URL Service:'),
                                  TextFormField(
                                    controller: ctrl.txtAlamatURL,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Nama Service:'),
                                TextFormField(
                                  enabled: !ctrl.loading.value,
                                  controller: ctrl.txtNamaService,
                                ),
                              ],
                            ),
                          )
                        ],
                      ), 
                    
                      const SizedBox(height: 10,),
                      const Text('Keterangan:'),
                      TextFormField(
                        enabled: !ctrl.loading.value,
                        controller: ctrl.txtKeterangan,
                      ),
                      const SizedBox(height: 10,),
              
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column( 
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Alamat Server:'),
                                TextFormField(
                                  controller: ctrl.txtAlamatIPServer,
                                  enabled: !ctrl.loading.value,
                                  maxLength: 255,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  const Text('Port:'),
                                  TextFormField(
                                    enabled: !ctrl.loading.value,
                                    controller: ctrl.txtPortServer,
                                    maxLength: 5,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
              
                      Row(
                          children: [
                            Expanded(
                              child: Column( 
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    const Text('Username:'),
                                    TextFormField(
                                      enabled: !ctrl.loading.value,
                                      controller: ctrl.txtUserName,
                                    ), 
                                ],
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    const Text('Password:'),
                                    TextFormField(
                                      enabled: !ctrl.loading.value,
                                      controller: ctrl.txtPassword,
                                      obscureText: true,
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    const Text('Nama Container:'),
                                    TextFormField(
                                      enabled: !ctrl.loading.value,
                                      controller: ctrl.txtContainerName, 
                                    ),
                                ],
                              ),
                            )
                          ],
                      ),
              
                      SizedBox(height: 10,),
                      
                      Divider(),
                     
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                            onPressed: ctrl.loading.value == true ? null : (){
                              ctrl.simpan().then((e){
                                if(e){
                                  Get.back();
                                  Get.snackbar("Simpan Data", "Service berhasil ditambahkan");
                                }else{
                                  QuickAlert.show(context: context, type: QuickAlertType.warning,
                                    title: 'Simpan Data',
                                    text: 'Data gagal disimpan');
                                }
                              });
              
                          }, child: const Text('Simpan')),
              
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            onPressed: ctrl.loading.value == true ? null : (){
                              ctrl.testConnection().then((e){
                                if(e){
                                    QuickAlert.show(context: context, type: QuickAlertType.success,
                                      title: 'Tes Koneksi',
                                      text: 'Koneksi ke ${ctrl.txtAlamatIPServer.value.text} berhasil'
                                    );
                                }else{
                                   
                                }
                              });
                          }, child: ctrl.loading.value == true ? const CupertinoActivityIndicator() : const Text('Test Connection'))
                        ],
                      )
                  ],
                ),
              );
            }
          ),
 
        ],
      ),
    );
  }
}