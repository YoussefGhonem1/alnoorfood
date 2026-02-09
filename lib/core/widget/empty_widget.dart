import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../config/app_color.dart';
import '../../config/text_style.dart';
import '../../feature/language/presentation/provider/language_provider.dart';
import '../constants/images.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  const EmptyWidget({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Images.emptyImage,color: AppColor.defaultColor,width: 23.w,fit: BoxFit.fitWidth,),
          SizedBox(height: 4.h,),
          Text(LanguageProvider.translate("empty", title),
            style: TextStyleClass.semiHeadBoldStyle(),
          textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}
