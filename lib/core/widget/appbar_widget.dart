import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../feature/auth/presentation/pages/login_page.dart';
import '../../feature/category/presentation/provider/category_provider.dart';
import '../../feature/notification/presentation/provider/notification_provider.dart';
import '../../feature/option/presentation/provider/options_provider.dart';
import '../../feature/product/presentation/provider/search_product_provider.dart';
import '../../feature/product/presentation/provider/stock_product_provider.dart';
import '../../feature/settings/presentation/pages/settings_page.dart';
import '../../feature/settings/presentation/provider/settings_provider.dart';
import '../constants/constants.dart';
import '../constants/images.dart';
import '../constants/var.dart';
import '../helper_function/loading.dart';
import '../helper_function/navigation.dart';
import 'button_widget.dart';
import 'logo_widget.dart';


PreferredSizeWidget appBarWidget(){
  return AppBar(
    leadingWidth: 0,
    title: LogoWidget(width: 20.w),
    actions: [
      if(isUser)IconButtonWidget(icon: Images.searchSVG, onTap: ()async{
        loading();
        Future.wait([
          Provider.of<CategoryProvider>(Constants.globalContext(),listen: false).refresh(),
          // Provider.of<OptionsProvider>(Constants.globalContext(),listen: false).refresh(),
        ]).then((value) {
          navPop();
          Provider.of<SearchProductProvider>(Constants.globalContext(),listen: false).goToSearchPage();
        });

      }),
      if(!isGuest)
        IconButtonWidget(icon: Images.notificationSVG, onTap: (){
          Provider.of<NotificationProvider>(Constants.globalContext(),listen: false).goNotificationPage();
        }),
      if(!isUser&&!isGuest&&deliveryEntity!.isAdmin)
        IconButtonWidget(icon: Images.materialeSVG, onTap: ()async{
          Provider.of<StockProductProvider>(Constants.globalContext(),listen: false).goToStockPage();
        }),
      if(isGuest)
        IconButtonWidget(icon: Images.logoutSVG, onTap: (){
          navPARU(LoginPage());
        }),
      if(!isUser&&!isGuest)
        IconButtonWidget(icon: Images.personSVG, onTap: (){
          Provider.of<SettingsProvider>(Constants.globalContext(),listen: false).setDeliverySettings();
          navP(SettingsPage());
        }),
      SizedBox(width: 2.w,),
    ],
  );
}
