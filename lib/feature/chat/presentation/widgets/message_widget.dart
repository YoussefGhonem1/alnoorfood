import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homsfood/feature/chat/domain/entities/support_message_entity.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/widget/img_preview_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({Key? key, required this.messageEntity,}) : super(key: key);
  final SupportMessageEntity messageEntity;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget>{



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: widget.messageEntity.fromMe()?MainAxisAlignment.start:MainAxisAlignment.end,
        children: [
          if(widget.messageEntity.type=='text')Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 65.w,
                minWidth: 20.w,
              ),
              // width: 65.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: (widget.messageEntity.fromMe())?Colors.black:AppColor.defaultColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.messageEntity.message,
                  style: TextStyle(color: Colors.white,fontSize: 12.sp),
                textAlign: Provider.of<LanguageProvider>(context,listen: false).appLocal.languageCode=='en'?
                    TextAlign.start:TextAlign.end,),
              ),
            ),
          ),
          if(widget.messageEntity.type=='image')Row(
            mainAxisAlignment: widget.messageEntity.fromMe()?MainAxisAlignment.start:MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){
                  navP(ImagePreviewWidget(imgPath: widget.messageEntity.isFile?null:widget.messageEntity.message,
                  img: !widget.messageEntity.isFile?null:XFile(widget.messageEntity.message),showSendButton: false,));
                },
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 30.w,
                    maxHeight: 22.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.defaultColor,width: 2),
                    image: DecorationImage(
                      image: widget.messageEntity.imageProvider(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if(widget.messageEntity.type=='audio')Container(
            width: Constants.isTablet? 50.w:null,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.defaultColor,width: 2),
            ),
            child: VoiceMessageView(
              controller: widget.messageEntity.voiceController!,
              innerPadding: 12,
              cornerRadius: 8,
              activeSliderColor: AppColor.defaultColor,
              backgroundColor: Colors.white,
              circlesColor: AppColor.defaultColor,
              size: (Constants.isTablet?5.w:30),
              circlesTextStyle: TextStyleClass.normalStyle(color: Colors.white),
              counterTextStyle: TextStyleClass.normalStyle(),

            ),
          ),

        ],
      ),
    );
  }
}
