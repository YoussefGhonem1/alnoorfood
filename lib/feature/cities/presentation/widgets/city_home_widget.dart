import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/city_provider.dart';

class CityHomeWidget extends StatelessWidget {
  CityHomeWidget({super.key, });
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    CityProvider cityProvider =Provider.of(context,);
    cityProvider.pagination(controller);
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LanguageProvider.translate("home", "goal_today"),style: TextStyleClass.semiStyle()),
                // Text(LanguageProvider.translate("home", "see_all"),style: TextStyleClass.normalStyle(color: AppColor.defaultColor)),

              ],
            ),
          ),
          SizedBox(height: 1.5.h,),
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: controller,
            child: Row(
              children: [
                Row(
                    children: List.generate(cityProvider.cityList.length, (index) {
                      return InkWell(
                        onTap: (){
                          cityProvider.changeCity(cityEntity: cityProvider.cityList[index]);
                        },
                        child: Column(
                          children: [
                            Text(LanguageProvider.translate("home", cityProvider.cityList[index].name),
                              style: TextStyleClass.smallStyle(),)
                          ],
                        ),
                      );
                    },)
                ),
                if(cityProvider.paginationStarted) const LoadingWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
