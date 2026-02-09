import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/text_style.dart';
import '../../../language/presentation/provider/language_provider.dart';


class WarningWidget extends StatelessWidget {
  const WarningWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100.w,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
            child: Row(
              children: [
                const Icon(Icons.warning,color: Colors.black,size: 20,),
                SizedBox(width: 2.w,),
                Expanded(child: Text(LanguageProvider.translate("home", "warning"),
                  style: TextStyleClass.normalStyle(),),),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
