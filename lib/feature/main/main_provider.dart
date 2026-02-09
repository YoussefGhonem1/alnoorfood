import 'package:flutter/material.dart';
import 'package:homsfood/feature/auth/presentation/provider/auth_provider.dart';
import 'package:homsfood/feature/settings/presentation/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../cart/presentation/provider/cart_provider.dart';
import '../chat/presentation/provider/message_provider.dart';
import '../product/presentation/provider/favorite_product_provider.dart';
import '../product/presentation/provider/new_product_provider.dart';

class MainProvider extends ChangeNotifier{
  int index = 0;
  void setIndex(int index){
    // this.index = index;

    if(index==1){
      Provider.of<MessageProvider>(Constants.globalContext(),listen: false).goToMessagePage();
    }else if(index==2){
      Provider.of<FavoriteProductProvider>(Constants.globalContext(),listen: false).refresh();
      this.index = index;
    }else if(index==3){
      Provider.of<CartProvider>(Constants.globalContext(),listen: false).refresh();
      this.index = index;
    }else if(index==4){
      this.index = index;
    }else{
      this.index = index;
    }
    notifyListeners();
  }
}