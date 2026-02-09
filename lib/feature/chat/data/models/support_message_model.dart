import 'package:provider/provider.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helper_function/convert.dart';
import '../../domain/entities/support_message_entity.dart';
import '../../presentation/provider/message_provider.dart';

class SupportMessageModel extends SupportMessageEntity {
  SupportMessageModel({required super.id, required super.date,
    required super.type, required super.message, required super.isFile,
    required super.duration, required super.voiceController, required super.supportId, required super.fromAdmin});

  factory SupportMessageModel.fromJson(Map data){
    VoiceController? voiceController;
    if(data['type']=='audio'){
      voiceController = VoiceController(
        audioSrc:
        data['message'],
        onComplete: () {
          /// do something on complete
        },
        onPause: () {
          /// do something on pause
        },
        onPlaying: () {
          Provider.of<MessageProvider>(Constants.globalContext(),listen: false).
          stopAllControllers(data['message']);
        },
        onError: (err) {
          /// do somethin on error
        }, isFile: false,

        maxDuration: Duration(seconds: convertDataToDouble(data['duration']).toInt()),
      );
    }
    return SupportMessageModel(id: data['id'],
        fromAdmin: convertDataToBool(data['from_admin']),
        date: DateTime.parse(data['created_at']),
        isFile: false,
        // chatEntity: ChatModel.fromJson(data['chat']),
        voiceController: voiceController,
        duration: data['duration']!=null ?  convertDataToDouble(data['duration']) :null,
        // fileSize: convertDataToDouble(data['file_size']),
        type: data['type'], message: data['message'],
        supportId: convertStringToInt(data['support_id']));
  }

}


