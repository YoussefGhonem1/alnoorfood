
import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable{
  int id;
  String title;
  String body;
  DateTime dateTime;

  NotificationEntity({required this.id, required this.title,
    required this.body, required this.dateTime});

  @override
  // TODO: implement props
  List<Object?> get props => [id,title,body,dateTime];
}