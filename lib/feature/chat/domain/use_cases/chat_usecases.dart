import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homsfood/feature/chat/domain/entities/support_message_entity.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class ChatUseCases {
  ChatRepository chatRepository;

  ChatUseCases(this.chatRepository);

  Future<Either<DioException, ChatEntity>> getSupportChatDetails(Map<String, dynamic> data) async {
    return await chatRepository.getSupportChatDetails(data);
  }

  Future<Either<DioException, SupportMessageEntity>> createSupportMessage(Map<String, dynamic> data) async {
    return await chatRepository.createSupportMessage(data);
  }


  Future<Either<DioException, List<ChatEntity>>> getAllChats(Map<String, dynamic> data) async {
    return await chatRepository.getAllChats(data);
  }

  Future<Either<DioException, bool>> deleteChat(Map<String, dynamic> data) async {
    return await chatRepository.deleteChat(data);
  }

}
