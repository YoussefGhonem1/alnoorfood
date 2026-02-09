import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/images.dart';
import '../../domain/entities/address_entity.dart';
import 'map_provider.dart';

class BottomMapSheetProvider extends ChangeNotifier{
  bool expanded = false;
  int id = 0;
  List<Map> inputs = [
    {"key":"address_name","image":Images.locationSVG,"value":TextEditingController(),
      "label":"address_name","show":false},
    {"key":"recipient_name","image":Images.activePersonSVG,"value":TextEditingController(),
      "label":"address_receiver_name","show":false},
    {"key":"recipient_number","image":Images.phoneSVG,"value":TextEditingController(),
      "label":"phone","type":TextInputType.phone,"show":true},
    {"key":"address","image":Images.locationSVG,"value":TextEditingController(),
      "label":"address_street","show":true},
  ];

  void setUpdatedData(AddressEntity addressEntity){
    id = addressEntity.id;
    inputs.firstWhere((element) => element['key']=='address_name')['value'].text = addressEntity.name;
    inputs.firstWhere((element) => element['key']=='recipient_name')['value'].text = addressEntity.recipientName;
    inputs.firstWhere((element) => element['key']=='recipient_number')['value'].text = addressEntity.recipientNumber;
    inputs.firstWhere((element) => element['key']=='address')['value'].text = addressEntity.address;
  }
  void resetData(){
    id = 0;
    expanded = false;
    for(var i in inputs){
      i['value'].clear();
    }
  }
  void triggerExtend(){
    if(expanded){
      disAbleExtend();
    }else{
      enableExtend();
    }
  }
  void enableExtend(){
    expanded = true;
    MapProvider  mapProvider = Provider.of(Constants.globalContext(),listen: false);
    String val = inputs.firstWhere((element) => element['label']=='address_street')["value"].text;
    if(val.isEmpty){
      inputs.firstWhere((element) => element['label']=='address_street')["value"].text = mapProvider.description;
    }
    notifyListeners();
  }
  void disAbleExtend(){
    expanded = false;
    notifyListeners();
  }
}