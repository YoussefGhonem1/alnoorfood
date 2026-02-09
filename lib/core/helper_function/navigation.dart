import 'package:flutter/material.dart';
import '../constants/constants.dart';

void navP(className, {void Function(dynamic val)? then}){
  Navigator.push(Constants.globalContext(),
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 600), // Make the animation take 2 seconds
      pageBuilder: (_, __, ___) => className,
    ),
    // MaterialPageRoute(builder: (context)=>className),
  ).then((value) {
    if(then!=null){
      then(value);
    }
  });
}
void navPR(className){
  Navigator.pushReplacement(Constants.globalContext(), MaterialPageRoute(builder: (context)=>className));
}
void navPARU(className){
  Navigator.pushAndRemoveUntil(Constants.globalContext(), MaterialPageRoute(builder: (context)=>className), (route) => false);
}
void navPop([dynamic val]){
  Navigator.pop(Constants.globalContext(),val);
}
void navPU(){
  Navigator.popUntil(Constants.globalContext(), (route) => route.isFirst);
}