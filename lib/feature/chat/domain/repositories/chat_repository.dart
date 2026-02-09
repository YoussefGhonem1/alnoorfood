import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homsfood/feature/chat/domain/entities/support_message_entity.dart';
import '../entities/chat_entity.dart';

abstract class ChatRepository {
  Future<Either<DioException, List<ChatEntity>>> getAllChats(Map<String, dynamic> data);
  Future<Either<DioException, bool>> deleteChat(Map<String, dynamic> data);
  Future<Either<DioException, ChatEntity>> getSupportChatDetails(Map<String, dynamic> data);
  Future<Either<DioException, SupportMessageEntity>> createSupportMessage(Map<String, dynamic> data);
}
