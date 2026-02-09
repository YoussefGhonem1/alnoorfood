import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/location.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../presentation/pages/map_page.dart';
import '../../presentation/provider/bottom_map_sheet.dart';
import '../../presentation/provider/map_provider.dart';
import '../entities/address_entity.dart';
import '../entities/map_image.dart';

class MapUseCases{
  static Future goMapPage()async{
    loading();
    Position? position;
    try{
      await MapImageClass.instance.loadImage('assets/map_icon.png');
      position = await determinePosition();
    }catch(e){

      print('$e');
    }
    navPop();
    if(position!=null){
      MapProvider mapProvider = Provider.of(Constants.globalContext(),listen: false);
      BottomMapSheetProvider bottomMapSheetProvider = Provider.of(Constants.globalContext(),listen: false);
      mapProvider.resetData();
      bottomMapSheetProvider.resetData();
      mapProvider.setData(position.latitude, position.longitude);
      navP(const MapPage(),then: (val){
        mapProvider.resetData();
        bottomMapSheetProvider.resetData();
      });
    }

  }
  static Future goMapPageUpdate(AddressEntity addressEntity)async{
    try{
      await MapImageClass.instance.loadImage('assets/map_icon.png');
    }catch(e){

      print('$e');
    }
    MapProvider mapProvider = Provider.of(Constants.globalContext(),listen: false);
    BottomMapSheetProvider bottomMapSheetProvider = Provider.of(Constants.globalContext(),listen: false);
    mapProvider.resetData();
    bottomMapSheetProvider.resetData();
    mapProvider.setData(addressEntity.lat, addressEntity.lng);
    bottomMapSheetProvider.setUpdatedData(addressEntity);
    navP(MapPage(),then: (val){
      mapProvider.resetData();
      bottomMapSheetProvider.resetData();
    });

  }
}