import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homsfood/feature/chat/presentation/provider/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../domain/entities/chat_entity.dart';
import '../provider/message_provider.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.chatEntity});
  final ChatEntity chatEntity;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: InkWell(
            onTap: () {
              Provider.of<MessageProvider>(context, listen: false).goToMessagePage(id: chatEntity.id, isSupport: true);
            },
            child: Column(children: [
              Row(
                children: [
                  Container(
                    width: 9.w,
                    height: 9.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(Images.logo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(chatEntity.userClass.name, style: TextStyleClass.semiBoldStyle())),
                            // Text(convertDateToTime(chatEntity.lastMessage?.date ?? DateTime.now()), style: TextStyleClass.normalStyle(color: Colors.grey))
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(chatEntity.userClass.phone, style: TextStyleClass.normalStyle()),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  InkWell(onTap: (){
                    Provider.of<ChatProvider>(context, listen: false).deleteChat(id: chatEntity.id);
                  },child: Icon(Icons.delete,color: Colors.red,size: 30,)),
                ],
              ),
              SizedBox(height: 1.h),
              Divider(color: Colors.grey.shade200, thickness: 0.15.h)
            ])));
  }
}
