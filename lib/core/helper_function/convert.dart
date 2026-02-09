import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../feature/language/presentation/provider/language_provider.dart';
import '../constants/constants.dart';



int convertStringToInt(dynamic value){
  if(value==null){
    return 0;
  }else
  if(value is int){
    return value;
  }else
  if(int.tryParse(value)!=null){
    return int.parse(value);
  }
  return 0;
}

num convertDataToNum(dynamic value){
  if(value==null){
    return 0;
  }else
  if(value is num){
    return value;
  }else
  if(num.tryParse(value)!=null){
    return num.parse(value);
  }
  return 0;
}

double convertDataToDouble(dynamic value){
  if(value==null){
    return 0;
  }else
  if(value is int){
    return value.toDouble();
  }else if(value is String){
    return double.parse(value);
  }else{
    return value;
  }
}

String convertMapToString(Map data){
  String msg = '';
  data.forEach((key, value) {
    if(value is List){
      msg = value.join('\n');
    }else
    if(value is String){
      msg += "$value\n";
    }
  });
  if(msg.endsWith('\n')){
    msg = msg.substring(0,msg.length-1);
  }
  return msg;
}

bool convertDataToBool(dynamic data){
  if(data==null){
    return false;
  }else
  if(data is num){
    return data==1;
  }else if(data is String){
    if(int.tryParse(data)==null){
      return data=='yes';
    }
    return convertStringToInt(data)==1;
  }else{
    return data;
  }
}

String convertDateToDayName(DateTime dateTime){
  String dayName = DateFormat('EEEE',Provider.of<LanguageProvider>
    (Constants.globalContext(),listen: false).appLocal.languageCode).format(dateTime);
  return dayName;
}

Map convertStringToMap(String data){
  String jsonString = data.replaceAll('{', '{"').replaceAll('}', '"}').replaceAll('=', '":"').replaceAll(', ', '","');
  return jsonDecode(jsonString);
}

String convertDateTimeToString(DateTime dateTime){
  return DateFormat('MMM d, y hh:mm a',
      Provider.of<LanguageProvider>(Constants.globalContext(),listen: false).appLocal.languageCode)
      .format(dateTime);
}

String convertDateToString(DateTime dateTime){
  return DateFormat('MMM d, y',
      Provider.of<LanguageProvider>(Constants.globalContext(),listen: false).appLocal.languageCode)
      .format(dateTime);
}

String convertDateToStringSort(DateTime dateTime){
  return DateFormat('d-M-y',
      Provider.of<LanguageProvider>(Constants.globalContext(),listen: false).appLocal.languageCode)
      .format(dateTime);
}

String addStringToPrice(String price){
  price =  num.parse(price).toStringAsFixed(2);
  if(price.contains('.')){
    List<String> string = price.split('.');
    string.first = string.first.padLeft(2,'');
    string.last = string.last.padRight(2,'0');
    return string.join('.');
  }
  return '$price.00';
}
String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

String formatTimeToAm(DateTime dateTime) {
  // Create a formatter for the time pattern
  final timeFormatter = DateFormat('h:mm a', Provider.of<LanguageProvider>(Constants.globalContext()).appLocal.languageCode);

  // Format the DateTime object to a string
  return timeFormatter.format(dateTime);
}

int convertToSeconds(String time) {
  List<String> parts = time.split(':');
  int minutes = int.parse(parts[0]);
  int seconds = int.parse(parts[1]);
  return (minutes * 60) + seconds;
}