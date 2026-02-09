import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/dialog/date_dialog.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';

class DateFilterWidget extends StatelessWidget {
  final String? from,to;
  final Color? color,textColor;
  final void Function(String fromDate,String toDate) onFilter;
  final void Function() reset;
  const DateFilterWidget({Key? key, required this.from, required this.to, required this.onFilter,
    required this.reset, this.color, this.textColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            TextEditingController controller1 = TextEditingController();
            TextEditingController controller2 = TextEditingController();
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight:  Radius.circular(36),
                ),
              ),
              builder: (context) {
                return Container(
                  width: 100.w,
                  constraints: BoxConstraints(
                    maxHeight: 43.h,
                    minHeight: 43.h,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight:  Radius.circular(36),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 6.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(LanguageProvider.translate('global', 'filter'),style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),),
                              InkWell(
                                onTap: (){
                                  reset();
                                  navPop();
                                },
                                child: Row(
                                  children: [
                                    Text(LanguageProvider.translate('global', 'reset'),style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    SizedBox(width: 2.w,),
                                    Icon(Icons.refresh,color: AppColor.defaultColor,size: Constants.isTablet?40:20,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h,),
                          TextFieldWidget(controller: controller1,onTextTap: ()async{
                            DateTime? t1 = await selectFilterDate();
                            if(t1==null&&controller1.text==""){
                              controller1.clear();
                            }else{
                              if(t1!=null){
                                controller1.text = t1.toLocal().toString().split(' ').first;
                              }
                            }
                          },readOnly: true,hintText: 'from'),
                          TextFieldWidget(controller: controller2,onTextTap: ()async{
                            DateTime? t1 = await selectFilterDate();
                            if(t1==null&&controller2.text==""){
                              controller2.clear();
                            }else{
                              if(t1!=null){
                                controller2.text = t1.toLocal().toString().split(' ').first;
                              }
                            }
                          },readOnly: true,hintText: 'to'),
                          SizedBox(height: 2.h,),
                          ButtonWidget(onTap: ()async{
                            if(controller1.text!=''&&controller2.text!=''){
                              onFilter(controller1.text,controller2.text);
                            }
                          }, text: 'filter'),

                        ],
                      ),
                    ),
                  ),
                );
              },
              isScrollControlled: true,
            );
          },
          child: Container(
            width: 90.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: color??AppColor.defaultColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                children: [
                  Text(from==null?LanguageProvider.translate('global', 'latest'):
                  ('${LanguageProvider.translate('global', 'from')} : ${from!}  '
                      '${to==null?"":"${LanguageProvider.translate('global', 'to')} $to"}'),
                    style: TextStyle(
                    color: textColor??Colors.white,
                    fontSize: 15.sp,
                  ),textAlign: TextAlign.start,),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h,),
      ],
    );
  }
}
