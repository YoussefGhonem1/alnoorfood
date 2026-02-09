import 'package:flutter/material.dart';
import '../../config/app_color.dart';
import '../constants/var.dart';
import '../dialog/guest_dialog.dart';
import '../models/favorite_class.dart';

class FavoriteButtonWidget extends StatefulWidget {
  final Favorite favorite;
  const FavoriteButtonWidget({required this.favorite,Key? key}) : super(key: key);

  @override
  State<FavoriteButtonWidget> createState() => FavoriteButtonWidgetState(favorite);
}

class FavoriteButtonWidgetState extends State<FavoriteButtonWidget> {
  Favorite favorite;
  FavoriteButtonWidgetState(this.favorite);
  @override
  Widget build(BuildContext context) {
    if(!isUser){
      return SizedBox();
    }
    return IconButton(onPressed: ()async{
      if(!isGuest){
        if(favorite.isFavorite){
          await favorite.removeFavorite();
        }else{
          await  favorite.addFavorite();
        }
        setState(() {

        });
      }else{
        showGuestDialog();
      }
    }, icon: Icon(Icons.favorite,color: favorite.isFavorite?Colors.red:AppColor.greyColor,
    size: 25,),padding: EdgeInsets.zero,);
  }
}
