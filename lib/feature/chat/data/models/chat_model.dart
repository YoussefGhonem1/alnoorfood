
import 'package:homsfood/feature/auth/data/models/user_class_model.dart';
import 'package:homsfood/feature/auth/domain/entities/user_class.dart';
import 'package:homsfood/feature/chat/data/models/support_message_model.dart';

import '../../domain/entities/chat_entity.dart';


class ChatModel extends ChatEntity {
  ChatModel({required super.id, required super.messages, required super.date, required super.userClass,});
  factory ChatModel.fromJson(Map data){
    List<SupportMessageModel> messages = [];
    if(data.containsKey('messages')&&data['messages']!=null){
      for(var i in data['messages']){
        messages.add(SupportMessageModel.fromJson(i));
      }
    }
    UserClassModel userClass = UserClassModel.fromJson(data['user']);
    return ChatModel(
      id: data['id'],
      messages: messages,
      date: DateTime.parse(data['created_at']), userClass: userClass,
    );
  }

}
