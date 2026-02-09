import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homsfood/core/constants/var.dart';
import 'package:homsfood/feature/chat/data/models/support_message_model.dart';
import '../../../../core/helper_function/api.dart';
import '../models/chat_model.dart';

class ChatRemoteDataSources {

  Future<Either<DioException, ChatModel>> getSupportChatDetails(Map<String, dynamic> data) async {
    var response = await ApiHandel.getInstance.post('${isUser?"user":"delivery"}/get_support_chat_details', data);
    return response.fold((l) => Left(l), (r) {
      return Right(ChatModel.fromJson(r.data['data']));
    });
  }

  Future<Either<DioException, SupportMessageModel>> createSupportMessage(Map<String, dynamic> data) async {
    var response = await ApiHandel.getInstance.post('${isUser?"user":"delivery"}/create_support_message', data);
    return response.fold((l) => Left(l), (r) {
      return Right(SupportMessageModel.fromJson(r.data['data']));
    });
  }
  Future<Either<DioException, bool>> deleteChat(Map<String, dynamic> data) async {
    var response = await ApiHandel.getInstance.post('delivery/delete_chat', data);
    return response.fold((l) => Left(l), (r) {
      return Right(true);
    });
  }
  Future<Either<DioException, List<ChatModel>>> getAllChats(Map<String, dynamic> data) async {
    var response = await ApiHandel.getInstance.get('delivery/get_all_chats', data);
    return response.fold((l) => Left(l), (r) {
      List<ChatModel> list = [];
      for(var i in r.data['data']){
        list.add(ChatModel.fromJson(i));
      }
      return Right(list);
    });
  }

}
