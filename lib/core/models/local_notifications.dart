import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../../feature/chat/presentation/provider/message_provider.dart';
import '../../main.dart';
import '../constants/constants.dart';
import '../constants/var.dart';
import '../helper_function/convert.dart';
import '../helper_function/helper_function.dart';

class NotificationLocalClass {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static Future notificationDet()async{
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'test','c_name',importance: Importance.max,priority: Priority.high,
          showWhen: false,playSound: true,channelShowBadge: true,channelDescription: 'c_des'
      ),
      iOS: DarwinNotificationDetails(

      ),
    );
  }
  static Future showNoti({int? id,required String title,required String body,required String payload})async{
    try{
      notificationsPlugin.show(id??DateTime.now().millisecond, title, body,await notificationDet(),payload: payload);
      // delay(2500).then((value) => notificationsPlugin.cancelAll());
    }catch(e){
      print(e);
    }
  }
  static Future init({bool initScheduled = false})async{
    final settings = InitializationSettings(
      android: const AndroidInitializationSettings('logo'),
      iOS: DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          defaultPresentBadge: true,
          onDidReceiveLocalNotification: (id,title,body,pay)async{
            clickNoti(pay!);
          }
      ),
    );
    await notificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (pay)async{
          clickNoti(pay.payload!);
        },
      onDidReceiveBackgroundNotificationResponse: localMessagingBackgroundHandler,
    );
  }
}

void clickNoti(String pay)async{
  NotificationLocalClass.notificationsPlugin.cancelAll();
  if(!isGuest&&sharedPreferences.getBool('login')==true){
    Map payload = jsonDecode(pay);
    if(payload.containsKey('message_type_')){
      if(payload['message_type_']=="support_chat"){
        Map message = jsonDecode(payload['data_']);
        print('message1');
        MessageProvider messageProvider = Provider.of(Constants.globalContext(),listen: false);
        print('message2');
        bool check = messageProvider.checkMessageOfThisChat(convertStringToInt(message['chat']['id']));
        print('message3');
        if(!check){
          print('message4');

          if(messageProvider.chatEntity==null){
            print('message5');
            messageProvider.goToMessagePage(id: convertStringToInt(message['chat']['id']),isSupport: true);
          }else{
            print('message6');
            messageProvider.getMessages(chatId: convertStringToInt(message['chat']['id']));
          }
        }
      }
    }
  }
}