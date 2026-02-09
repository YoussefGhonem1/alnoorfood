import 'package:homsfood/feature/auth/domain/entities/user_class.dart';
import 'package:homsfood/feature/chat/domain/entities/support_message_entity.dart';


class ChatEntity{
  int id;
  List<SupportMessageEntity> messages;
  DateTime? date;
  UserClass userClass;
  ChatEntity(
      {required this.id, required this.messages, required this.date,required this.userClass});
}
