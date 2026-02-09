import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../provider/language_provider.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<Map> languages = [
      {"name":"Arabic","code":"ar"},
      // {"name":"English","code":"en"},
     // {"name":"Italiano","code":"it"},
      {"name":"Deutsch","code":"de"},
      {"name":"Francais","code":"fr"},
    ];
    return SizedBox(
      width: 100.w,
      child: Consumer<LanguageProvider>(
        builder: (context,provider,_) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                mainAxisSpacing: 2.h,
                shrinkWrap: true,
                children: List.generate(languages.length, (index) => GestureDetector(
                  onTap: (){
                    provider.setLanguage(Locale(languages[index]['code'],""));
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(150),
                                boxShadow: [
                                  BoxShadow(color: provider.language.languageCode==languages[index]['code']?AppColor.defaultColor:Colors.grey.shade300
                                      ,blurRadius: 1,spreadRadius: 1,offset: const Offset(0,3)),
                                ]
                            ),
                            child: Container(
                              width: 30.w,
                              height: 21.h,
                              decoration: BoxDecoration(
                                color: provider.language.languageCode==languages[index]['code']?AppColor.lightDefaultColor:Colors.white,
                                borderRadius: BorderRadius.circular(150),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 2.w),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10.h,child: Image.asset('assets/${languages[index]['code']}.png',fit: BoxFit.cover,)),
                                    SizedBox(height: 2.h,),
                                    Text(languages[index]['name'],style: TextStyleClass.normalStyle(),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ),
            ),
          );
        }
      ),
    );
  }
}





