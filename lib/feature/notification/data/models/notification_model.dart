import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity{
  NotificationModel({required super.id, required super.title,
    required super.body, required super.dateTime});

  factory NotificationModel.fromJson(Map data){
    return NotificationModel(id: data['id'], title: data['title'],
        body: data['message'], dateTime: DateTime.parse(data['created_at']));
  }

}