import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:homsfood/core/constants/var.dart';
import 'package:provider/provider.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../auth/presentation/provider/auth_provider.dart';

class SupportMessageEntity extends Equatable {
  int id;
  int supportId;
  String type;
  String message;
  bool fromAdmin;
  DateTime date;
  bool isFile;
  double? duration;
  VoiceController? voiceController;

  SupportMessageEntity(
      {required this.id, required this.date, required this.type,
        required this.message, required this.isFile, required this.duration,
        required this.voiceController, required this.supportId, required this.fromAdmin});

  @override
  List<Object?> get props => [id, type, fromAdmin,message, duration];

  bool fromMe(){
    return !((isUser&&!fromAdmin)||(!isUser&&fromAdmin));
  }

  ImageProvider imageProvider(){
    return (isFile?FileImage(File(message)):CachedNetworkImageProvider(message)) as ImageProvider;
  }

}
