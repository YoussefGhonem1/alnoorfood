import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/text_style.dart';
import '../../../../core/helper_function/convert.dart';
import '../provider/message_provider.dart';
import 'message_widget.dart';


class MessagesWidget extends StatelessWidget {
  const MessagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    MessageProvider messageProvider = Provider.of(context);
    return Expanded(
      child: ListView(
        reverse: true,
        controller: messageProvider.controllerList,
        children: List.generate(messageProvider.chatEntity?.messages.length??3, (i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
            child: Column(
              children: [
                // if((i==messageProvider.chatEntity!.messages.length-1))DateChatWidget(messageEntity: messageProvider.chatEntity!.messages[i]),
                MessageWidget(messageEntity: messageProvider.chatEntity!.messages[i]),
                Row(
                  mainAxisAlignment: messageProvider.chatEntity!.messages[i]
                      .fromMe()?MainAxisAlignment.start:MainAxisAlignment.end,
                  children: [
                    Text(formatTimeToAm(messageProvider.chatEntity!.messages[i].date),style: TextStyleClass.smallStyle(),),
                  ],
                ),
                // if(((i!=0&&((messageProvider.chatEntity!.messages[i].date.toLocal().toString().split(' ').first))
                //     !=(messageProvider.chatEntity!.messages[i-1].date.toLocal().toString().split(' ').first))))DateChatWidget(messageEntity: messageProvider.chatEntity!.messages[i-1]),


              ],
            ),
          );
        }),
      ),
    );
  }
}
