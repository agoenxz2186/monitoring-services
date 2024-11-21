
import 'package:get/get.dart';
import 'package:monitoring_service/models/services_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MonitoringController extends GetxController{
   RefreshController refreshController = RefreshController(initialRefresh: true);
   RxList<ServiceModel> listData = <ServiceModel>[].obs;

   Future _loadData()async{
      final ls = await ServiceModel().get();
      listData.clear();
      for(var n in ls){
         listData.value.add( ServiceModel.fromMap(n) );
      }
      refreshController.refreshCompleted();
   }

   Future onRefresh()async=>_loadData();
}