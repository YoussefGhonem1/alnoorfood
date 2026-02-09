import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';

class SettingsWidget extends StatelessWidget {
  final Map data;
  const SettingsWidget({required this.data,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: InkWell(
        onTap: data['onTap'],
        child: Container(
          width: 100.w,
          height: 6.5.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.lightGreyColor.withOpacity(0.7)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
            child: Row(
              children: [
                SvgWidget(svg: data['image'],color: data['title'] !='delete_account' ? Colors.black: data['color'] ,
                width: 25,),
                SizedBox(width: 3.w,),
                Expanded(
                  child: Text(LanguageProvider.translate('settings', data['title']),
                  maxLines: 1,
                  style: TextStyleClass.normalStyle(color: data['color']),),
                ),
                if(data['show_arrow']!=false)const Icon(Icons.arrow_forward_ios,size: 15,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
