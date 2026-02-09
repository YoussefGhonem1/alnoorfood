
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:homsfood/core/constants/var.dart';
import 'package:homsfood/feature/chat/domain/entities/support_message_entity.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/helper_function/image.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/widget/img_preview_widget.dart';
import '../../../../injection_container.dart';
import '../../data/models/support_message_model.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/use_cases/chat_usecases.dart';
import '../pages/message_page.dart';

class MessageProvider extends ChangeNotifier {
  ChatEntity? chatEntity;
  // List<String> automaticMessages = [];

  final TextEditingController controller = TextEditingController();
  ScrollController controllerList = ScrollController();
  void stopAllControllers(String path) {
    for (var i in chatEntity?.messages ?? []) {
      if (i.type == 'audio') {
        if (i.message != path) {
          i.voiceController!.pausePlaying();
        }
      }
    }
  }

  bool checkMessageOfThisChat(int id) {
    if (chatEntity != null && chatEntity!.id == id) {
      return true;
    }
    return false;
  }

  void scrollToBottom() async {
    try {
      controllerList.animateTo(controllerList.position.minScrollExtent,
          curve: Curves.linear, duration: const Duration(milliseconds: 100));
    } catch (e) {
      print('e');
    }
  }

  void selectImageChat() async {
    XFile? image = await chooseImage();
    if (image != null) {
      navP(ImagePreviewWidget(
        img: image,
        showSendButton: true,
      ));
    }
  }

  void clear() {
    stopAllControllers('');
    chatEntity = null;
    controller.clear();
    id = null;
  }

  Future addMessage({dynamic file, required String type, int? sec, String? message}) async {
    Either<DioException, SupportMessageEntity> response;
    Map<String, dynamic> data = {};
    // double size = 0;
    if (file != null) {
      // int fileSizeInBytes = await file.length();
      // size = fileSizeInBytes / 1024;
      data['message'] = await MultipartFile.fromFile(file.path);
      if(type == "audio"){
        data['duration'] = sec?.toDouble() ?? 0;
      }
    } else {
      data['message'] = message ?? controller.text;
    }
    // AuthProvider auth = Provider.of(Constants.globalContext(), listen: false);
    data['from_admin'] = !isUser ? 1 : 0;
    data['support_id'] = chatEntity!.id;

    data['type'] = type;

    controller.clear();
    chatEntity?.messages.insert(
        0,
        SupportMessageModel(
          supportId: data['support_id'],
          message: file?.path ?? data['message'],
          date: DateTime.now(),
          id: 0,
          type: type,
          isFile: true,
          duration: sec?.toDouble() ?? 0,
          voiceController: type != "audio"
              ? null
              : VoiceController(
                  audioSrc: file!.path,
                  onComplete: () {
                    /// do something on complete
                  },
                  onPause: () {
                    /// do something on pause
                  },
                  onPlaying: () {
                    stopAllControllers(file!.path);
                  },
                  onError: (err) {
                    /// do something on error
                  },
                  isFile: true,
                  maxDuration: Duration(seconds: (sec ?? 0).toInt()),
                ),
          fromAdmin: convertDataToBool(data['from_admin']),
        ),
    );
    notifyListeners();
    response = await ChatUseCases(sl()).createSupportMessage(data);
    response.fold((l) {
      showToast(l.message ?? "");
    }, (r) {
      // playSuccessSound(path: 'new_message.mp4');

    });
    notifyListeners();
  }

  void addOneMessage(SupportMessageEntity messageEntity) {
    chatEntity?.messages.insert(0,messageEntity);
    notifyListeners();
  }

  Future getMessages({int? chatId}) async {
    Map<String, dynamic> data = {};
    Either<DioException, ChatEntity> response;
    loading();
    if(chatId!=null){
      id = chatId;
    }
    if(id!=null){
      data['support_id'] = id;
    }
    response = await ChatUseCases(sl()).getSupportChatDetails(data);
    navPop();

    response.fold((l) {
      showToast(l.message!);
    }, (r) {
      chatEntity = r;
      if (r.messages.isEmpty) {

      }
      notifyListeners();
    });
  }

  void refresh() {
    clear();
    getMessages();
  }
  int? id;
  void goToMessagePage({int? id, bool isSupport = false}) async {
    this.id = id;
    await getMessages();
    navP(const MessagePage(), then: (val) {
      clear();
    });
  }

  void rebuild() {
    notifyListeners();
  }
}
