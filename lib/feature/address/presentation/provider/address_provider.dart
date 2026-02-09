import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/dialog/success_dialog.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../injection_container.dart';
import '../../../cart/presentation/provider/check_out_provider.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/use_cases/address_usecases.dart';
import '../../domain/use_cases/go_map_page.dart';
import 'bottom_map_sheet.dart';
import 'map_provider.dart';

class AddressProvider extends ChangeNotifier{
  List<AddressEntity>? address;
  AddressEntity? selectedAddress;
  int pageIndex = 1;
  bool finish = false;
  void selectAddress(AddressEntity? address){
    selectedAddress = address;
    notifyListeners();
  }
  // void selectBillingAddress(AddressEntity? address){
  //   selectedBillingAddress = address;
  //   notifyListeners();
  // }
  void clear(){
    address = null;
    pageIndex = 1;
    notifyListeners();
  }
  void refresh(){
    clear();
    getAddress();
  }
  void getAddress()async{
    Either<DioException,List<AddressEntity>> value = await AddressUseCases(sl()).getAddress(pageIndex);
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      address ??= [];
      address!.addAll(r);
      pageIndex++;
      notifyListeners();
    });
  }
  void addAddress()async{
    MapProvider mapProvider = Provider.of(Constants.globalContext(),listen: false);
    BottomMapSheetProvider bottomMapSheetProvider = Provider.of(Constants.globalContext(),listen: false);
    List<Map> inputs = bottomMapSheetProvider.inputs;
    Map<String,dynamic> data = {};

    for (var element in inputs) {
      data[element['key']] = element['value'].text;
    }
    data['latitude'] = mapProvider.lat;
    data['longitude'] = mapProvider.lng;
    loading();
    Either<DioException, AddressEntity> value = await AddressUseCases(sl()).addAddress(data);
    navPop();
    value.fold((l)  {
      showToast(l.message!);
    }, (r) async {
      address??= [];
      address!.add(r);
      notifyListeners();
      successDialog(msg: 'address',then: (){
        navPop();
      });
    });
  }
  void updateAddress()async{
    MapProvider mapProvider = Provider.of(Constants.globalContext(),listen: false);
    BottomMapSheetProvider bottomMapSheetProvider = Provider.of(Constants.globalContext(),listen: false);
    List<Map> inputs = bottomMapSheetProvider.inputs;
    Map<String,dynamic> data = {};

    for (var element in inputs) {
      data[element['key']] = element['value'].text;
    }
    data['id'] = bottomMapSheetProvider.id;
    data['latitude'] = mapProvider.lat;
    data['longitude'] = mapProvider.lng;
    loading();
    Either<DioException, AddressEntity> value = await AddressUseCases(sl()).updateAddress(data);
    navPop();
    value.fold((l)  {
      showToast(l.message!);
    }, (r) async {
      address??= [];
      int index = address!.indexWhere((element) => element.id==bottomMapSheetProvider.id);
      if(index!=-1){
        address![index] = r;
      }
      notifyListeners();
      successDialog(msg: 'update_address',then: (){
        navPop();
      });
    });
  }
  void deleteAddress(AddressEntity addressEntity)async{
    Map<String,dynamic> data = {};
    data['address_id'] = addressEntity.id;
    loading();
    Either<DioException, bool> value = await AddressUseCases(sl()).deleteAddress(data);
    navPop();
    value.fold((l)  {
      showToast(l.message!);
    }, (r) async {
      CheckOutProvider checkOutProvider = Provider.of(Constants.globalContext(),listen: false);
      if(checkOutProvider.addressEntity?.id==addressEntity.id){
        // selectedAddress = null;
        // Provider.of<CheckOutProvider>(Constants.globalContext(),
        //     listen: false).selectAddress(null);
      }
      // if(checkOutProvider.addressBillingEntity?.id==addressEntity.id){
      //   // selectedBillingAddress = null;
      //   Provider.of<CheckOutProvider>(Constants.globalContext(),
      //       listen: false).selectBillingAddress(null);
      // }
      address!.remove(addressEntity);
      notifyListeners();
    });
  }
  Future goMapPage()async{
    MapUseCases.goMapPage();
  }
  Future goMapPageUpdate(AddressEntity addressEntity)async{
    MapUseCases.goMapPageUpdate(addressEntity);
  }
}