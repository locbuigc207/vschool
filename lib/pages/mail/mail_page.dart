import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vschool/commons/repository/notification_repository.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/pages/common_error_page.dart';
import 'package:vschool/commons/widgets/pages/no_data_page.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/notification/bloc/notification_page_bloc.dart';
import 'package:vschool/pages/notification/notification_page.dart';
import 'package:vschool/pages/notification/widget/notification_shimmer_loading.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class MailPage extends StatefulWidget {
  const MailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  late RefreshController _refreshController;
  final _scrollController = ScrollController();
  bool _isVisible = true;

  late int _studentId = 0;

  @override
  void initState() {
    getChildId();
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

  void getChildId() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final studentId = preferences.getInt('studentId');
    print('SharedPreferences studentId: $studentId');
    if (studentId != null) {
      setState(() {
        _studentId = studentId;
      });
      print('Set _studentId to: $_studentId');
    } else {
      print('studentId is null from SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('MailPage build - _studentId: $_studentId');
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Thông báo',
      hasBack: false,
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
                child: _studentId > 0 
                    ? MultiBlocProvider(
                        providers: [
                          BlocProvider(
                              create: (_) => NotificationPageBloc(
                                  notificationRepository:
                                      getIt<INotificationRepository>())
                                ..add(NotificationFetched(
                                    receiverId: _studentId.toString()))),
                        ],
                        child: BlocConsumer<NotificationPageBloc, NotificationPageState>(
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
                                        receiverId: _studentId.toString())),
                              );
                            } else if (state.notificationList.isEmpty) {
                              // Nếu không có lỗi và danh sách trống thì hiển thị empty page
                              return NoDataPage(
                                title: 'Không có thông báo!',
                                subtitle: 'Bạn chưa có thông báo nào',
                                onTap: () => context
                                    .read<NotificationPageBloc>()
                                    .add(NotificationFetched(
                                        receiverId: _studentId.toString())),
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
                                            receiverId: _studentId.toString())),
                                    onLoading: () => context
                                        .read<NotificationPageBloc>()
                                        .add(NotificationFetched(
                                            receiverId: _studentId.toString())),
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
                      )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Đang tải thông tin học sinh...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Sarabun',
                                ),
                              ),
                            ],
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
