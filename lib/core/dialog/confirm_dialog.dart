import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/text_style.dart';
import '../../feature/language/presentation/provider/language_provider.dart';

void confirmDialog(context,String title,String confirm,void Function() confirmTap,
    {String? cancel,void Function()? cancelTap}){
  showCupertinoModalPopup<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => Transform.scale(
      scale: 1,
      child: CupertinoAlertDialog(
        title: Text(title,style: TextStyleClass.normalStyle(),),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: cancelTap??() {
              Navigator.pop(context);
            },
            child: Text(cancel??LanguageProvider.translate('buttons', 'no')
              ,style: TextStyleClass.normalStyle(),),
          ),
          CupertinoDialogAction(
            onPressed: confirmTap,
            child: Text(confirm,style: TextStyleClass.normalStyle(color: Colors.red),),
          )
        ],
      ),
    ),
  );
}