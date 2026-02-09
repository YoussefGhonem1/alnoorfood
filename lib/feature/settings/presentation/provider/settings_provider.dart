import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/helper_function/helper_function.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../auth/presentation/provider/edit_account_provider.dart';
import '../../../chat/presentation/provider/chat_provider.dart';
import '../../../delivery_visit/presentation/provider/delivery_visit_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../material/presentation/provider/material_provider.dart';
import '../../../order/presentation/provider/order_provider.dart';
import '../../../product/presentation/pages/new_page.dart';
import '../../../product/presentation/provider/new_product_provider.dart';
import '../../../support/presentation/provider/support_provider.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/use_cases/settings_usecase.dart';
import '../pages/web_view.dart';
import 'delivery_visits_provider.dart';

class SettingsProvider extends ChangeNotifier{
  SettingsEntity? settingsEntity;

  List<Map> settingsUser = [
    {"image":Images.settingsSVG,"title":"edit_profile","onTap":(){
      Provider.of<EditAccountProvider>(Constants.globalContext(),listen: false).goToEditPage();
    },},

    // {"image":Images.materialeSVG,"title":"material","onTap":(){
    //   Provider.of<MaterialProvider>(Constants.globalContext(),listen: false).goToMaterialPage();
    // }},
    {"image":Images.ordersSVG,"title":"delivery_visits","onTap":(){
      Provider.of<DeliveryVisitsProvider>(Constants.globalContext(),listen: false).goToDeliveryVisitsPage();
    },},
    {"image":Images.ordersSVG,"title":"orders","onTap":(){
      Provider.of<OrdersProvider>(Constants.globalContext(),listen: false).goOrdersPage();
    }},
    {"image":Images.supportSVG,"title":"support","onTap":(){
      Provider.of<SupportProvider>(Constants.globalContext(),listen: false).goToSupportPage();
    }},
    {"image":Images.newSVG,"title":"new","onTap":(){
      navP(NewPage());
      Provider.of<NewProductProvider>(Constants.globalContext(),listen: false).refresh();

    }},
    {"image":Images.privacySVG,"title":"privacy","onTap":(){}},
    {"image":Images.aboutSVG,"title":"about","onTap":(){}},
    {"image":Images.termsSVG,"title":"terms","onTap":(){}},
    {
      "image": Images.changeLanguage,
      "title": "language",
      "onTap": () {
        Provider.of<LanguageProvider>(Constants.globalContext(),listen: false).showLangDialog();
      },
    },
    {"image":Images.deleteAccountSVG,"title":"delete_account","onTap":(){
      Provider.of<AuthenticationProvider>(Constants.globalContext(),listen: false).confirmDeleteAccount();
    },"color":Colors.red,"show_arrow":false},

  ];
  List<Map> deliverySettings = [
    {"image":Images.settingsSVG,"title":"edit_profile","onTap":(){
      Provider.of<EditAccountProvider>(Constants.globalContext(),listen: false).goToEditPage();
    },},
    if(deliveryEntity?.isAdmin??false){"image":Images.ordersSVG,"title":"delivery_visits","onTap":(){
      Provider.of<DeliveryVisitProvider>(Constants.globalContext(),listen: false).goToDeliveryVisitPage();
    },},
    {"image":Images.supportSVG,"title":"support","onTap":(){
      Provider.of<SupportProvider>(Constants.globalContext(),listen: false).goToSupportPage();
    }},
    if(deliveryEntity?.isChat??false){"image":Images.supportSVG,"title":"support_live","onTap":(){
      Provider.of<ChatProvider>(Constants.globalContext(),listen: false).goToChatPages();
    }},
    {"image":Images.privacySVG,"title":"privacy","onTap":(){}},
    {"image":Images.aboutSVG,"title":"about","onTap":(){}},
    {"image":Images.termsSVG,"title":"terms","onTap":(){}},
    {
      "image": Images.changeLanguage,
      "title": "language",
      "onTap": () {
        Provider.of<LanguageProvider>(Constants.globalContext(),listen: false).showLangDialog();
      },
    },
  ];
  // void setDataSettings(){
  //   deliverySettings = [
  //     {"image":Images.settingsSVG,"title":"edit_profile","onTap":(){
  //     Provider.of<EditAccountProvider>(Constants.globalContext(),listen: false).goToEditPage();
  //   },},
  //     if(deliveryEntity?.isAdmin??false){"image":Images.ordersSVG,"title":"delivery_visits","onTap":(){
  //       Provider.of<DeliveryVisitProvider>(Constants.globalContext(),listen: false).goToDeliveryVisitPage();
  //     },},
  //     {"image":Images.supportSVG,"title":"support","onTap":(){
  //       Provider.of<SupportProvider>(Constants.globalContext(),listen: false).goToSupportPage();
  //     }},
  //     {"image":Images.privacySVG,"title":"privacy","onTap":(){}},
  //     {"image":Images.aboutSVG,"title":"about","onTap":(){}},
  //     {"image":Images.termsSVG,"title":"terms","onTap":(){}},
  //     {
  //       "image": Images.changeLanguage,
  //       "title": "language",
  //       "onTap": () {
  //         Provider.of<LanguageProvider>(Constants.globalContext(),listen: false).showLangDialog();
  //       },
  //     },
  //   ];
  // }
  List<Map> settings(){
    return isUser?settingsUser:deliverySettings;
  }
  void getSettings()async{
    Either<DioException,SettingsEntity> value = await SettingsUseCases(sl()).getSettings();
    value.fold((l) {
      delay(2000).then((value) => getSettings());
    }, (r) {
      settingsEntity = r;
      settingsUser.firstWhere((element) => element['title']=='privacy')['onTap'] = (){
        navP(WebViewPage(title: "privacy", link: r.privacy));
      };
      settingsUser.firstWhere((element) => element['title']=='terms')['onTap'] = (){
        navP(WebViewPage(title: "terms", link: r.terms));
      };
      settingsUser.firstWhere((element) => element['title']=='about')['onTap'] = (){
        navP(WebViewPage(title: "about", link: r.about));
      };
      deliverySettings.firstWhere((element) => element['title']=='privacy')['onTap'] = (){
        navP(WebViewPage(title: "privacy", link: r.privacy));
      };
      deliverySettings.firstWhere((element) => element['title']=='terms')['onTap'] = (){
        navP(WebViewPage(title: "terms", link: r.terms));
      };
      deliverySettings.firstWhere((element) => element['title']=='about')['onTap'] = (){
        navP(WebViewPage(title: "about", link: r.about));
      };
    });
  }

  void changeMarketStatus()async{
    loading();
    Either<DioException,SettingsEntity> value = await SettingsUseCases(sl()).getSettings();
    value.fold((l) {
      delay(2000).then((value) => getSettings());
    }, (r){
      // if(settingsEntity?.isOpen !=null){
      //   settingsEntity?.isOpen= ! settingsEntity!.isOpen;
      // }
    });
  }

  void setDeliverySettings() {
    deliverySettings = [
      {"image":Images.settingsSVG,"title":"edit_profile","onTap":(){
        Provider.of<EditAccountProvider>(Constants.globalContext(),listen: false).goToEditPage();
      },},
      {"image":Images.supportSVG,"title":"support","onTap":(){
        Provider.of<SupportProvider>(Constants.globalContext(),listen: false).goToSupportPage();
      }},
      // {"image":Icons.local_printshop_rounded,"title":"choose_printer","onTap":(){
      //   navP(PrintersPage(order: null));
      // }},
      if(deliveryEntity?.isChat??false){"image":Images.supportSVG,"title":"support_live","onTap":(){
        Provider.of<ChatProvider>(Constants.globalContext(),listen: false).goToChatPages();
      }},
      {"image":Images.privacySVG,"title":"privacy","onTap":(){}},
      {"image":Images.aboutSVG,"title":"about","onTap":(){}},
      {"image":Images.termsSVG,"title":"terms","onTap":(){}},
      {
        "image": Images.changeLanguage,
        "title": "language",
        "onTap": () {
          Provider.of<LanguageProvider>(Constants.globalContext(),listen: false).showLangDialog();
        },
      },

    ];
    deliverySettings.firstWhere((element) => element['title']=='privacy')['onTap'] = (){
      navP(WebViewPage(title: "privacy", link: settingsEntity!.privacy));
    };
    deliverySettings.firstWhere((element) => element['title']=='terms')['onTap'] = (){
      navP(WebViewPage(title: "terms", link: settingsEntity!.terms));
    };
    deliverySettings.firstWhere((element) => element['title']=='about')['onTap'] = (){
      navP(WebViewPage(title: "about", link: settingsEntity!.about));
    };
    notifyListeners();
  }

  void rebuild() {
    notifyListeners();
  }
  void changeOpen(){
    settingsEntity?.isOpen= ! settingsEntity!.isOpen;
    notifyListeners();
  }
}