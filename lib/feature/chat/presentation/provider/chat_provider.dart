import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:homsfood/core/helper_function/loading.dart';
import 'package:homsfood/core/helper_function/navigation.dart';
import 'package:homsfood/feature/chat/presentation/pages/chats_page.dart';

import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/models/pagination_class.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/use_cases/chat_usecases.dart';

class ChatProvider extends ChangeNotifier implements PaginationClass {
  List<ChatEntity>? chats;
  @override
  int pageIndex = 1;
  void clear() {
    chats = null;
    paginationStarted = false;
    paginationFinished = false;
    pageIndex = 1;
  }

  Future getChat() async {
    Map<String, dynamic> data = {};
    data['page'] = pageIndex;
    Either<DioException, List<ChatEntity>> value =
        await ChatUseCases(sl()).getAllChats(data);
    value.fold((l) {
      showToast(l.message!);
      debugPrint(l.message.toString());
    }, (r) {
      if(pageIndex==1&&chats!=null&&chats!.isNotEmpty){
        chats?.clear();
      }
      pageIndex++;
      chats ??= [];
      for(var i in r){
        int index = chats!.indexWhere((element) => element.id == i.id);
        if(index!=-1){
          chats![index] = i;
        }else{
          chats?.add(i);
        }
      }
      if (r.isEmpty) {
        paginationFinished = true;
      }
    });
    paginationStarted = false;
    notifyListeners();
  }

  void refresh() {
    clear();
    notifyListeners();
    getChat();
  }

  void goToChatPages(){
    refresh();
    navP(ChatsPage());
  }

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;

  @override
  void pagination(ScrollController controller) {
    controller.addListener(() async {
      if (controller.position.atEdge && controller.position.pixels > 50) {
        if (!paginationFinished &&
            !paginationStarted &&
            chats != null &&
            chats!.isNotEmpty) {
          paginationStarted = true;
          notifyListeners();
          await getChat();
        }
      }
    });
  }

  void deleteChat({required int id}) async{
    Map<String,dynamic> data = {};
    data['id'] = id;
    loading();
    Either<DioException, bool> value =
        await ChatUseCases(sl()).deleteChat(data);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      int index = chats!.indexWhere((element) => element.id == id);
      if (index != -1) {
        chats!.removeAt(index);
        notifyListeners();
      }
    });
  }
}
