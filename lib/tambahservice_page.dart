import 'package:flutter/material.dart';

class TambahservicePage extends StatelessWidget {
  const TambahservicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.all(20),
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
                          TextFormField(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nama Service:'),
                        TextFormField(),
                      ],
                    ),
                  )
                ],
              ),
               SizedBox(height: 10,),
             
            
              SizedBox(height: 10,),
              Text('Keterangan:'),
              TextFormField(),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Alamat Server:'),
                        TextFormField(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          const Text('Port:'),
                          TextFormField(),
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
                        children: [
                            Text('Username:'),
                            TextFormField(),
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        children: [
                            Text('Password:'),
                            TextFormField(
                              obscureText: true,
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
                    onPressed: (){


                  }, child: const Text('Simpan')),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    onPressed: (){

                  }, child: Text('Test Connection'))
                ],
              )
          ],
        ),
      ),
    );
  }
}