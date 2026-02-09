import 'package:flutter/material.dart';
import 'package:homsfood/core/helper_function/navigation.dart';
import 'package:homsfood/core/widget/button_widget.dart';
import 'package:sizer/sizer.dart';

import '../constants/constants.dart';
import '../models/drop_down_class.dart';
import '../widget/drop_down_option_widget.dart';

Future showDropDownDialog(DropDownClass dropDownClass)async{
  FocusScope.of(Constants.globalContext()).unfocus();
  await showModalBottomSheet(
    context: Constants.globalContext(),
    backgroundColor:Colors.white.withOpacity(0.8),
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(36),
        topRight:  Radius.circular(36),
      ),
    ),
    builder: (context) {
      return GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: 100.w,
          constraints: BoxConstraints(
            maxHeight: 45.h,
            minHeight: 45.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight:  Radius.circular(36),
            ),
          ),
          child: StatefulBuilder(
            builder: (context,setState) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 3.h,),
                            ...List.generate(dropDownClass.list().length, (index) {
                              dynamic data = dropDownClass.list()[index];
                              return DropDownOptionWidget(dropDownClass: dropDownClass, data: data,
                              rebuild: (){
                                setState((){});
                              },);
                            }),

                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
                    child: ButtonWidget(onTap: (){
                      navPop();
                    }, text: "save"),
                  ),
                ],
              );
            }
          ),
        ),
      );
    },
    isScrollControlled: true,
  );
}