import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/constants.dart';

bool isLoadingStart = false;
void loading(){
  isLoadingStart = true;
  showDialog(
    context: Constants.globalContext(),
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: true,
        onPopInvoked: (val)async{

        },
        child: Opacity(
          opacity: 1,
          child: Container(
            width: 100.w,
            height: 100.h,
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Transform.scale(scale: 2,
                      child: const CupertinoActivityIndicator(color: Colors.black,)),
                ),
              ),
            ),
          ),
        ),
      );
    },
  ).then((value) {
    isLoadingStart = false;
  });
}