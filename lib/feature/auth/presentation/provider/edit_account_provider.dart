import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/dialog/drop_down_dialog.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/dialog/success_dialog.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/text_field_model.dart';
import '../../../../injection_container.dart';
import '../../../address/presentation/provider/bottom_map_sheet.dart';
import '../../../address/presentation/provider/map_provider.dart';
import '../../../cities/presentation/provider/city_provider.dart';
import '../../domain/entities/delivery_entity.dart';
import '../../domain/entities/user_class.dart';
import '../../domain/use_cases/auth_usecases.dart';
import '../pages/edit_page.dart';
import 'auth_provider.dart';

class EditAccountProvider extends ChangeNotifier{
  List<TextFieldModel> userInputs = [
    // {"key":"name","image":Images.personSVG,"value":TextEditingController(),
    //   "label":"name",},
    // // {"key":"client_directive","image":Images.personSVG,"value":TextEditingController(),
    // //   "label":"client_directive",},
    // {"key":"phone","image":Images.phoneOutlinedSVG,"value":TextEditingController(),
    //   "label":"phone","type":TextInputType.phone},
    // // {"key":"user_name","image":Images.personSVG,"value":TextEditingController(),
    // //   "label":"company_user",},
    // // {"key":"work_time","image":Images.editSVG,"value":TextEditingController(),
    // //   "label":"open_close_time",},
    //
    // {"key":"email","image":Images.emailSVG,"value":TextEditingController(),
    //   "label":"email",'type':TextInputType.emailAddress},
    // {"key":"password","image":Images.passSVG,"value":TextEditingController(),
    //   "label":"pass","hint":"************","next":false},
  ];
  List<TextFieldModel> deliveryInputs = [
    // {"key":"name","image":Images.personSVG,"value":TextEditingController(),
    //   "label":"name",},
    // {"key":"email","image":Images.emailSVG,"value":TextEditingController(),
    //   "label":"email",'type':TextInputType.emailAddress},
    // {"key":"phone","image":Images.phoneOutlinedSVG,"value":TextEditingController(),
    //   "label":"phone","type":TextInputType.phone},
    // {"key":"password","image":Images.passSVG,"value":TextEditingController(),
    //   "label":"pass","hint":"************","next":false},
  ];
  List<TextFieldModel> inputs(){
    return isUser?userInputs:deliveryInputs;
  }
  void goToEditPage(){
    if(isUser){
      initInputs();
    }else{
      initDeliveryInputs();
    }
    navP(EditPage());
  }
  AuthenticationProvider authenticationProvider = Provider.of(Constants.globalContext(),listen: false);
  CityProvider cityProvider = Provider.of(Constants.globalContext(),listen: false);
  void initInputs(){

    userInputs = [
      TextFieldModel(
          key: "name",
          controller: TextEditingController(text: authenticationProvider.userEntity!.name),
          label: "name",
          image: Images.personSVG,
          // validator: (value) => validateName(value!),
          hint: "name"),
      TextFieldModel(
        key: "phone",
        controller: TextEditingController(text: authenticationProvider.userEntity!.phone ),
        label: "phone",
        image: Images.phoneSVG,
        textInputType: TextInputType.phone,
        // validator: (value) => validatePhone(value!),
        next: true,
        // suffix: const CountryWidget()
      ),
      TextFieldModel(
        key: "city_id",
        controller: TextEditingController(text: cityProvider.cityEntity?.name??""),
        label: "city",
        // image: Images.lockIcon,
        hint: "city",
        // validator: (value) => validatePassword(value!),
        readOnly: true,
        onTap: (){
          showDropDownDialog(cityProvider).then((v){
            userInputs.firstWhere((element) => element.key=="city_id",).controller.text = cityProvider.cityEntity?.name??"";
            notifyListeners();
          });
        },
        next: true,
      ),
      TextFieldModel(
        key: "email",
        controller: TextEditingController(text: authenticationProvider.userEntity!.email),
        label: "email",
        image: Images.emailSVG,
        textInputType: TextInputType.emailAddress,
        // validator: (value) => validateEmail(value!),
        hint: "email",
        next: false,
      ),

    ];
    // userInputs.firstWhere((element) => element['key']=='name')['value'].text =
    //     authenticationProvider.userEntity!.name;
    // userInputs.firstWhere((element) => element['key']=='client_directive')['value'].text =
    //     authenticationProvider.userEntity!.clientDirective??"";
    // userInputs.firstWhere((element) => element['key']=='phone')['value'].text =
    //     authenticationProvider.userEntity!.phone;
    // userInputs.firstWhere((element) => element['key']=='user_name')['value'].text =
    //     authenticationProvider.userEntity!.userName;
    // userInputs.firstWhere((element) => element['key']=='work_time')['value'].text =
    //     authenticationProvider.userEntity!.workTime;
    // userInputs.firstWhere((element) => element['key']=='email')['value'].text =
    //     authenticationProvider.userEntity!.email;
  }
  void initDeliveryInputs(){

    deliveryInputs = [
      TextFieldModel(
          key: "name",
          controller: TextEditingController(text: deliveryEntity!.name),
          label: "name",
          image: Images.personSVG,
          // validator: (value) => validateName(value!),
          hint: "name"),
      TextFieldModel(
        key: "phone",
        controller: TextEditingController(text: deliveryEntity!.phone ),
        label: "phone",
        image: Images.phoneSVG,
        textInputType: TextInputType.phone,
        // validator: (value) => validatePhone(value!),
        next: true,
        // suffix: const CountryWidget()
      ),
      TextFieldModel(
        key: "email",
        controller: TextEditingController(text: deliveryEntity!.email),
        label: "email",
        image: Images.emailSVG,
        textInputType: TextInputType.emailAddress,
        // validator: (value) => validateEmail(value!),
        hint: "email",
        next: false,
      ),

    ];

    // deliveryInputs.firstWhere((element) => element['key']=='name')['value'].text =
    //     deliveryEntity!.name;
    // deliveryInputs.firstWhere((element) => element['key']=='phone')['value'].text =
    //     deliveryEntity!.phone;
    // deliveryInputs.firstWhere((element) => element['key']=='email')['value'].text =
    //     deliveryEntity!.email;
  }
  void updateProfile({bool addAddressField = false}){
    if(isUser){
      updateUserProfile(addAddressField: addAddressField);
    }else{
      updateDeliveryProfile();
    }
  }
  BottomMapSheetProvider bottomMapSheetProvider = Provider.of(Constants.globalContext(),listen: false);
  void updateUserProfile({bool addAddressField = false})async{
    loading();
    Map<String,dynamic> data = {};
    for(var i in userInputs){
      if(i.key!="city_id"){
        data[i.key!] = i.controller.text;
      }
      if(i.key=="city_id"){
        int id = cityProvider.cityEntity?.id??0;
        if(id!=0){
          data['city_id'] = id;
        }
      }
    }
    if(addAddressField){
      for (var element in bottomMapSheetProvider.inputs) {
        data[element['key']] = element['value'].text == '' ? null : element['value'].text;
      }
      MapProvider mapProvider = Provider.of(Constants.globalContext(),listen: false);
      data['latitude'] = mapProvider.lat;
      data['longitude'] = mapProvider.lng;

    }
    Either<DioException,UserClass> value = await AuthUseCases(sl()).updateProfile(data);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      AuthenticationProvider authenticationProvider = Provider.of(Constants.globalContext(),listen: false);
      authenticationProvider.updateUser(r);
      successDialog(then: (){
        if(addAddressField)navPop();
        navPop();
      });
    });
  }
  void updateDeliveryProfile()async{
    loading();
    Map<String,dynamic> data = {};
    for(var i in deliveryInputs){
      data[i.key!] = i.controller.text;
    }
    print(data);
    Either<DioException,DeliveryEntity> value = await AuthUseCases(sl()).updateDeliveryProfile(data);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      AuthenticationProvider authenticationProvider = Provider.of(Constants.globalContext(),listen: false);
      authenticationProvider.updateDelivery(r);
      successDialog(then: (){
        navPop();
      });
    });
  }
}