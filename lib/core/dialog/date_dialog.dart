import 'package:flutter/material.dart';
import '../constants/constants.dart';

Future<DateTime?> selectDate({DateTime? init,DateTime? currentDate}) async {
  final DateTime? picked = await showDatePicker(
    context: Constants.globalContext(),
    initialDate: currentDate??DateTime.now().add(Duration(days: 1)),
    firstDate: init??DateTime.now().add(Duration(days: 1)),
    lastDate: DateTime.now().add(Duration(days: 365)),
  );
  return picked;
}
Future<DateTime?> selectFilterDate() async {
  final DateTime? picked = await showDatePicker(
    context: Constants.globalContext(),
    initialDate: DateTime.now(),
    firstDate: DateTime(DateTime.now().year-1),
    lastDate: DateTime.now(),
  );
  return picked;
}

Future<String?> selectTime() async {
  final TimeOfDay? picked = await showTimePicker(
    context: Constants.globalContext(),
    initialTime: TimeOfDay.now(), // You can set initial time here
  );
  if (picked != null) {
    print('Selected Time: ${picked.hour}:${picked.minute}');
    return '${picked.hour}:${picked.minute}';
  }
  return null;
}