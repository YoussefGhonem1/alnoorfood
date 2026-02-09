
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../feature/chat/data/models/support_message_model.dart';
import '../../feature/chat/presentation/provider/message_provider.dart';
import '../../feature/order/presentation/provider/order_delivery_provider.dart';
import '../constants/constants.dart';
import '../constants/var.dart';
import '../models/local_notifications.dart';
import 'convert.dart';
import 'helper_function.dart';



bool inChat = false; // var to know if you in chat page ot not

String? dataNoti; // to save last data of notification to use it from any ware
RemoteNotification? remoteNotification; // to save last data of notification to use it from any ware
bool inApp= false;
void notificationsFirebase()async{
  FirebaseMessaging.onMessage.listen((event) async{
    if(event.notification!=null){
      dataNoti = jsonEncode(event.data);
      remoteNotification = event.notification!;
      appNotifications(event.notification!,payload: jsonEncode(event.data),fromWhereClicked: 1);
    }
  });
  FirebaseMessaging.instance.getInitialMessage().then((event) async{
    if(event!=null&&event.notification!=null){
      while(!inApp){
        await delay(300);
      }

      dataNoti = jsonEncode(event.data);
      remoteNotification = event.notification!;
      appNotifications(remoteNotification!,click: true,fromWhereClicked: 2,
          payload: jsonEncode(event.data));
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) async{

    if(event.notification!=null){
      dataNoti = jsonEncode(event.data);
      remoteNotification = event.notification!;
      appNotifications(remoteNotification!,click: true,fromWhereClicked: 2,
      payload: jsonEncode(event.data));
      // if(appOpen){
      //   appNotifications(event.notification!,click: true);
      // }
    }
  });
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      sound: true, badge: false, alert: true,criticalAlert: true,provisional: true);

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {

  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {

  } else {

  }
}


void appNotifications(RemoteNotification data2,
    {bool click = false,bool start = false,String payload = '',required int fromWhereClicked})async {
  bool showNotificationLocal = true;
  if(payload.isNotEmpty){
    Map map = jsonDecode(payload);



    if(map.containsKey('message_type_')&&map['message_type_']=="support_chat"){
      Map message = jsonDecode(map['data_']);
      print(message);
      try{
        SupportMessageModel messageModel = SupportMessageModel.fromJson(message);
        print('message1');
        MessageProvider messageProvider = Provider.of(Constants.globalContext(),listen: false);
        print('message2');
        bool check = messageProvider.checkMessageOfThisChat(convertStringToInt(message['chat']['id']));
        print('message3 $check');
        if(check){
          messageProvider.addOneMessage(messageModel);
          showNotificationLocal = false;
        }
      }catch(e){
        print(e);
      }
    }
  }
  if(click&&!isGuest&&fromWhereClicked==2){
    // clickNoti(payload);
    // NotificationLocalClass.removeBadge();
    NotificationLocalClass.notificationsPlugin.cancelAll();
  }
  if(showNotificationLocal&&!isGuest&&!click){
    NotificationLocalClass.showNoti(title: data2.title??"", body: data2.body??"", payload: payload);
  }


}