import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/notification/notification_model.dart';
import 'package:vschool/commons/repository/notification_repository.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/pages/common_error_page.dart';
import 'package:vschool/commons/widgets/pages/no_data_page.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/notification/bloc/notification_page_bloc.dart';
import 'package:vschool/pages/notification/widget/notification_shimmer_loading.dart';

String studentName = '';

@RoutePage()
class NotificationPage extends StatefulWidget {
  final ChildrenInfoModel child;

  const NotificationPage({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late RefreshController _refreshController;
  final _scrollController = ScrollController();
  bool _isVisible = true;

  var parentPhoneNum = '';

  @override
  void initState() {
    studentName = widget.child.name!;

    _refreshController = RefreshController(initialRefresh: false);



    // Scroll controller
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Thông báo',
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
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => NotificationPageBloc(
                            notificationRepository:
                                getIt<INotificationRepository>())
                          ..add(NotificationFetched(
                              receiverId: (widget.child.studentId ?? 0).toString()))),
                  ],
                  child:
                      BlocConsumer<NotificationPageBloc, NotificationPageState>(
                    listener: (context, state) {
                      final error = state.error;

                      if (error == null) {
                        _refreshController.refreshCompleted();
                        _refreshController.loadComplete();
                      } else {
                        _refreshController.refreshFailed();
                        _refreshController.loadFailed();
                      }
                    },
                    builder: (context, state) {
                      final error = state.error;

                      if (state.isLoading || state.isRefreshing) {
                        return const NotificationShimmerLoading();
                      } else if (error != null) {
                        // Nếu có lỗi thì hiển thị error page
                        return CommonErrorPage(
                          message: 'Không thể tải thông báo: ${state.error}',
                          onTap: () => context.read<NotificationPageBloc>().add(
                              NotificationFetched(
                                  receiverId:
                                      (widget.child.studentId ?? 0).toString())),
                        );
                      } else if (state.notificationList.isEmpty) {
                        // Nếu không có lỗi và danh sách trống thì hiển thị empty page
                        return NoDataPage(
                          title: 'Không có thông báo!',
                          subtitle: 'Bạn chưa có thông báo nào',
                          onTap: () => context
                              .read<NotificationPageBloc>()
                              .add(NotificationFetched(
                                  receiverId:
                                      (widget.child.studentId ?? 0).toString())),
                        );
                      } else {
                        // Nếu có dữ liệu thì hiển thị danh sách
                        final lstNotifi = state.notificationList;
                        return SmartRefresher(
                              controller: _refreshController,
                              physics: const BouncingScrollPhysics(),
                              enablePullDown: true,
                              enablePullUp: true,
                              onRefresh: () => context
                                  .read<NotificationPageBloc>()
                                  .add(NotificationFetched(
                                      receiverId:
                                          (widget.child.studentId ?? 0).toString())),
                              onLoading: () => context
                                  .read<NotificationPageBloc>()
                                  .add(NotificationFetched(
                                      receiverId:
                                          (widget.child.studentId ?? 0).toString())),
                              child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final notifi = lstNotifi[index];
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        16.w,
                                        index == 0 ? 24.h : 0.h,
                                        16.w,
                                        index == lstNotifi.length - 1
                                            ? 80.h
                                            : 0.h,
                                      ),
                                      child: NotificationCard(
                                          notificationInfo: notifi),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 24.h),
                                  itemCount: lstNotifi.length),
                            );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationInfoModel notificationInfo;

  const NotificationCard({Key? key, required this.notificationInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushRoute(
        NotificationDetailRoute(notificationInfo: notificationInfo),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
            border: Border.all(color: ColorName.borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Assets.icons.aBrown.svg(),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationInfo.content ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Sarabun',
                      color: (notificationInfo.read ?? false) ? Colors.grey : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    studentName ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.w300,
                      color: (notificationInfo.read ?? false) ? Colors.grey : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Trân trọng thông báo quý phụ huynh của cháu ${studentName ?? ''}',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Sarabun',
                      color: (notificationInfo.read ?? false) ? Colors.grey : Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    DateFormat('HH:mm dd/MM/yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            notificationInfo.createdDate ?? 0)),
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.w300,
                      color: (notificationInfo.read ?? false) ? Colors.grey : Colors.black,
                    ),
                  ),
                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
