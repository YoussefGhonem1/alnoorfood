import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../../injection_container.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/delivery_entity.dart';
import '../../domain/entities/user_class.dart';
import '../../domain/use_cases/auth_usecases.dart';
import '../pages/reset_page.dart';

class OTPProvider extends ChangeNotifier{
  late String email;
  Timer?  _timer;
  DateTime? last;
  int counter = 60;
  bool clicked = false,wrong = false,isDialogOpen = false;
  void Function(void Function())? set;
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> code = List.generate(6, (index) => TextEditingController());
  void startTimer(){
    if(counter==60){
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (e){
        if((_timer?.isActive??false)&&counter>0){
          try{
            counter--;
            set?.call((){});
            notifyListeners();
          }catch(e){
            print(e);
          }
        }
        if(counter==0){
          e.cancel();
        }
      });
    }
  }
  void reSend()async{
    if(counter==0){
      _timer?.cancel();
      isDialogOpen = true;
      navPop();
      checkEmail(email);
    }
  }
  void sendOTP(String email){
    for (var element in code) {element.clear();}
    this.email = email;
    last = DateTime.now();
    counter = 60;
    clicked = false;
    wrong = false;
    startTimer();
    showModalBottomSheet(context: Constants.globalContext(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (context){
          return Form(
            key: _formKey,
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  width: 90.w,
                  height: 60.h,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 3.h,),
                          Image.asset(Images.otpImage,width: 50.w,),
                          SizedBox(height: 2.h,),
                          Text(LanguageProvider.translate("otp", "title").replaceAll("**input1**", email),
                            textAlign: TextAlign.center,),
                          FormField(
                            builder: (state) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(code.length, (index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0.5.w),
                                        child: TextFieldWidget(controller: code[index],hintText: 'X',
                                          width: 14.w,height: 9.h,borderColor: Colors.transparent,
                                          cursorColor: Colors.transparent,
                                          maxLength: 6,
                                          keyboardType: TextInputType.numberWithOptions(),
                                          validator: (val){
                                          return null;
                                          },
                                          focusedBorder: AppColor.defaultColor,
                                          autoFocus: index==0,
                                          onChange: (val){
                                            if(val.length==2){
                                              code[index].text = val[1];
                                              if(index!=code.length-1){
                                                FocusScope.of(context).nextFocus();
                                              }else{
                                                FocusScope.of(context).unfocus();
                                              }
                                            }else
                                            if(val.length==6){
                                              for(int u = 0;u<6;u++){
                                                code[u].text = val[u];
                                              }
                                              FocusScope.of(context).unfocus();
                                            }else
                                            if(val!=""||val.isNotEmpty){
                                              if(index==0){
                                                if(index!=code.length-1){
                                                  FocusScope.of(context).nextFocus();
                                                  // FocusScope.of(context).nextFocus();
                                                }else{
                                                  FocusScope.of(context).unfocus();
                                                }
                                              }else{
                                                bool findEmpty = false;
                                                for(int i = 0;i<i;i++){
                                                  if(code[i].text.isEmpty){
                                                    for(int o=0;o<(i-i-1);o++){
                                                      FocusScope.of(context).previousFocus();
                                                      // FocusScope.of(context).previousFocus();
                                                    }
                                                    code[i].clear();
                                                    code[i].text = val;
                                                    findEmpty = true;
                                                    break;
                                                  }
                                                }
                                                if(!findEmpty){
                                                  if(index!=code.length-1){
                                                    FocusScope.of(context).nextFocus();
                                                    // FocusScope.of(context).nextFocus();
                                                  }else{
                                                    FocusScope.of(context).unfocus();
                                                  }
                                                }

                                              }
                                            }
                                            else{
                                              if(code[index].text.isEmpty&&index>0){
                                                FocusScope.of(context).previousFocus();
                                              }else{
                                                code[index].clear();
                                              }
                                            }
                                          },
                                          counter: "",
                                          color: AppColor.lightDefaultColor,textAlign: TextAlign.center,
                                          style: TextStyleClass.headBoldStyle(color: AppColor.defaultColor),),
                                      );
                                    }),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: state.errorText!=null?1.h:0),
                                    child: Text(
                                      state.errorText ?? '',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                        fontSize: 9.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            validator: (val){
                              bool check = false;
                              for(var i in code){
                                if(i.text.isEmpty){
                                  check = true;
                                }
                              }
                              if(wrong){
                                return LanguageProvider.translate("validation", "wrong_code");
                              }
                              if(check){
                                return LanguageProvider.translate("validation", "field");
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 1.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(LanguageProvider.translate("otp", "resend"),
                              style: TextStyleClass.normalStyle(),),
                              StatefulBuilder(
                                builder: (context,set) {
                                  this.set = set;
                                  return TextButton(
                                    child: Text('00:${counter.toString().padLeft(2,"0")}',
                                      style: TextStyleClass.normalStyle(),),
                                    onPressed: (){
                                      reSend();
                                    },
                                  );
                                }
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h,),
                          ButtonWidget(onTap: (){
                            if(_formKey.currentState!.validate()){
                              if(!clicked){
                                clicked = true;
                                FocusScope.of(context).unfocus();
                                String codeString = '';
                                for(var l in code){
                                  codeString += l.text;
                                }
                                checkCode(email,codeString);
                                clicked = false;
                              }
                            }
                          }, text: "confirm"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).then((value) => _timer?.cancel());
  }
  void checkEmail(String email)async{
    Map<String,dynamic> data = {};
    data['email'] = email;
    loading();
    Either<DioException, Either<UserClass,DeliveryEntity>> login = await AuthUseCases(sl()).checkEmail(data);
    navPop();
    login.fold((l)  {
      showToast(l.message!);
    }, (r)  {
      r.fold((l) {
        isUser = true;
      }, (r) {
        isUser = false;
      });
      sendOTP(email);
    });
  }
  void checkCode(String email,String codeString)async{
    Map<String,dynamic> data = {};
    data['email'] = email;
    data['code'] = codeString;
    loading();
    Either<DioException, bool> login;
    if(isUser){
      login =  await AuthUseCases(sl()).checkCode(data);
    }else{
      login = await AuthUseCases(sl()).checkDeliveryCode(data);
    }
    navPop();
    login.fold((l)  {
      wrong = true;
      for(var l in code){
        l.clear();
      }
      _formKey.currentState!.validate();
      wrong = false;
    }, (r)  {
      _timer?.cancel();
      navPR(ResetPage());
    });
  }
}

