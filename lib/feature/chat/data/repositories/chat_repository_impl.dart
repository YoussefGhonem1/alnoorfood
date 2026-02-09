import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/repositories/chat_repository.dart';
import '../data_sources/remote.dart';
import '../models/chat_model.dart';
import '../models/support_message_model.dart';

class ChatRepositoryImpl extends ChatRepository {
  @override
  Future<Either<DioException, bool>> deleteChat(Map<String, dynamic> data) async {
    return await ChatRemoteDataSources().deleteChat(data);
  }
  @override
  Future<Either<DioException, List<ChatModel>>> getAllChats(Map<String, dynamic> data) async {
    return await ChatRemoteDataSources().getAllChats(data);
  }

  @override
  Future<Either<DioException, SupportMessageModel>> createSupportMessage(Map<String, dynamic> data) async {
    return await ChatRemoteDataSources().createSupportMessage(data);
  }
  @override
  Future<Either<DioException, ChatModel>> getSupportChatDetails(Map<String, dynamic> data) async {
    return await ChatRemoteDataSources().getSupportChatDetails(data);
  }

}
