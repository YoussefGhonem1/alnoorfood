import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/widget/empty_widget.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/notification_provider.dart';
import '../widgets/notification_widget.dart';
import '../widgets/shimmer_notification_widget.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    NotificationProvider notificationProvider = Provider.of(context,listen: true);
    notificationProvider.pagination(scrollController,);
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageProvider.translate("main", "notification")),
      ),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: RefreshIndicator(
            onRefresh: ()async{
              notificationProvider.refresh();
            },
            child: Stack(
              children: [
                ListView.builder(
                  controller: scrollController,
                  physics: notificationProvider.notifications==null?const NeverScrollableScrollPhysics()
                      :const AlwaysScrollableScrollPhysics(),
                  itemCount: notificationProvider.notifications?.length??8,
                  itemBuilder: (ctx,i){
                    if(notificationProvider.notifications==null){
                      return const ShimmerNotificationWidget();
                    }
                    return NotificationWidget(notificationEntity: notificationProvider.notifications![i],);
                  },
                ),
                if(notificationProvider.notifications!=null
                    &&notificationProvider.notifications!.isEmpty)const EmptyWidget(title: 'notification'),
                if(notificationProvider.paginationStarted) const LoadingWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
