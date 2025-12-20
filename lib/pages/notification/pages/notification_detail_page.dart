import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/models/notification/notification_model.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/pages/notification/bloc/notification_page_bloc.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/commons/repository/notification_repository.dart';

@RoutePage()
class NotificationDetailPage extends StatefulWidget {
  final NotificationInfoModel notificationInfo;

  const NotificationDetailPage({Key? key, required this.notificationInfo})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationPageBloc(
        notificationRepository: getIt<INotificationRepository>(),
      )..add(NotificationReading(
          notificationId: widget.notificationInfo.notificationId ?? 0)),
      child: BasePage(
        backgroundColor: Colors.white,
        title: 'Chi tiết thông báo',
        child: Stack(
          children: [
            FadeAnimation(
              delay: 0.5,
              child: GradientHeaderContainer(height: 140.h),
            ),
            SafeArea(
              child: FadeAnimation(
                delay: 1,
                direction: FadeDirection.up,
                child: RoundedTopContainer(
                  margin: EdgeInsets.only(top: 16.h, bottom: 30.h),
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.notificationInfo.content ?? 'Không có nội dung',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
