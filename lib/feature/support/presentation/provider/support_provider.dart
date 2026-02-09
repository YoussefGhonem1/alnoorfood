import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/dialog/success_dialog.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../injection_container.dart';
import '../../domain/use_cases/support_usecases.dart';
import '../pages/support_page.dart';

class SupportProvider extends ChangeNotifier{
  final List<Map> inputs = [
    {"key":"name","image":Images.personSVG,"value":TextEditingController(),
      "label":"name",},
    {"key":"mail","image":Images.emailSVG,"value":TextEditingController(),
      "label":"email","type":TextInputType.emailAddress},
    {"key":"subject","image":Images.subjectSVG,"value":TextEditingController(),
      "label":"subject"},
    {"key":"message","image":Images.messageSVG,"value":TextEditingController(),
      "label":"message","max":8,"next":false},
  ];

  void clear(){
    for(var i in inputs){
      i['value'].clear();
    }
  }
  void goToSupportPage(){
    clear();
    navP(SupportPage());
  }
  void contactUs()async{
    Map<String,dynamic> data = {};
    for(var i in inputs){
      data[i['key']] = i['value'].text;
    }
    loading();
    Either<DioException,bool> value = await SupportUseCases(sl()).contactUs(data);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      successDialog(then: (){
        navPop();
      });
    });
  }
}