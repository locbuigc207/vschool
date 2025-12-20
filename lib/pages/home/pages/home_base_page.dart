import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vschool/commons/models/banner/banner_model.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/pages/home/bloc/home_bloc.dart';
import 'package:vschool/pages/home/widget/home_news_card.dart';
import 'package:vschool/pages/home/widget/list_menu_button.dart';

@RoutePage()
class HomeBasePage extends StatefulWidget {
  const HomeBasePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeBasePage();
}

class _HomeBasePage extends State<HomeBasePage> {
  // ignore: unused_field
  bool _isFirstRun = true;

  late String childName = '';

  late ChildrenInfoModel student = ChildrenInfoModel();

  late List<ChildrenInfoModel> lstChildren = [];

  late List<BannerModel> lstContent = [];

  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  // ignore: unused_field
  late Future<int> _studentId;

  @override
  void initState() {
    context.read<HomePageBloc>().add(const GetAllChildren());
    // context.read<HomePageBloc>().add(GetBannerContent());
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFirstRun = false;
    });
  }

  Future<void> _saveUserInfo(int studentId) async {
    final SharedPreferences preferences = await _preferences;
    preferences.setInt('studentId', studentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
      listener: (context, state) {
        if (state is GetAllChildrenInitial) {
          context.loaderOverlay.show();
        } else if (state is GetAllChildrenFailure) {
          context.loaderOverlay.hide();
          showErrorSnackBBar(context: context, message: state.mess ?? '');
        } else if (state is GetAllChildrenSuccess) {
          context.loaderOverlay.hide();
          lstChildren = state.children;
          if (childName == '') {
            childName = lstChildren.first.name!;
            student = lstChildren.first;
            _saveUserInfo(student.studentId!);
            context.read<HomePageBloc>().add(ChildChanged(child: student));
            context.read<HomePageBloc>().add(ChildChanged(child: student));
            print(student.name);
            print("1");
          } else {
            student =
                lstChildren.singleWhere((element) => element.name == childName);
            _saveUserInfo(student.studentId!);
            print(student.name);
            context.read<HomePageBloc>().add(ChildChanged(child: student));
            print("else");
          }
        } else if (state is GetBannerContentFailure) {
          context.loaderOverlay.hide();
          showErrorSnackBBar(context: context, message: state.mess);
        } else if (state is GetBannerContentSuccess) {
          context.loaderOverlay.hide();
          lstContent = state.data ?? [];
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                if (lstChildren.length >= 2)
                  Positioned(
                    top: 50.h,
                    right: 50.w,
                    child: Column(
                      children: [
                        Assets.icons.arrow.svg(),
                        SizedBox(height: 6.h),
                        const Text(
                          'Nhấn đổi con',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito'),
                        ),
                      ],
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 0),
                      child: Row(
                        children: [
                          const Text(
                            'Chào',
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sarabun'),
                          ),
                          TextButton(
                            onPressed: lstChildren.length < 2
                                ? () {}
                                : () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (contextDialog) {
                                        return Platform.isAndroid
                                            ? AlertDialog(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    14))),
                                                titlePadding:
                                                    EdgeInsets.fromLTRB(
                                                        20.w, 2.h, 4.w, 0),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        10.w, 0, 10.w, 20.h),
                                                content: Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: MediaQuery.of(
                                                                contextDialog)
                                                            .size
                                                            .width *
                                                        0.9,
                                                    maxHeight: MediaQuery.of(
                                                                contextDialog)
                                                            .size
                                                            .height *
                                                        0.6,
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: lstChildren
                                                          .map((child) {
                                                        return ChildrenSelectionCard(
                                                          isSelected:
                                                              childName ==
                                                                  child.name,
                                                          child: child,
                                                          onTap:
                                                              (selectedChild) {
                                                            setState(() {
                                                              childName =
                                                                  child.name!;
                                                              student = child;
                                                            });
                                                            _saveUserInfo(student
                                                                .studentId!);
                                                            context
                                                                .read<
                                                                    HomePageBloc>()
                                                                .add(ChildChanged(
                                                                    child:
                                                                        student));
                                                            Navigator.pop(
                                                                contextDialog);
                                                          },
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                                title: Row(
                                                  children: [
                                                    const Text(
                                                      'Chọn học sinh',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'Sarabun'),
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              contextDialog),
                                                      icon: const Icon(
                                                        Icons.cancel_rounded,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : CupertinoAlertDialog(
                                                title: Row(
                                                  children: [
                                                    const Text(
                                                      'Chọn học sinh',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'Sarabun'),
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              contextDialog),
                                                      icon: const Icon(
                                                        Icons.cancel_rounded,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                content: Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: MediaQuery.of(
                                                                contextDialog)
                                                            .size
                                                            .width *
                                                        0.9,
                                                    maxHeight: MediaQuery.of(
                                                                contextDialog)
                                                            .size
                                                            .height *
                                                        0.6,
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: lstChildren
                                                          .map((child) {
                                                        return ChildrenSelectionCard(
                                                          isSelected:
                                                              childName ==
                                                                  child.name,
                                                          child: child,
                                                          onTap:
                                                              (selectedChild) {
                                                            setState(() {
                                                              childName =
                                                                  child.name!;
                                                              student = child;
                                                            });
                                                            context
                                                                .read<
                                                                    HomePageBloc>()
                                                                .add(ChildChanged(
                                                                    child:
                                                                        student));
                                                            Navigator.pop(
                                                                contextDialog);
                                                          },
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              );
                                      },
                                    );
                                  },
                            child: SizedBox(
                              width: 195.w,
                              child: Text(
                                childName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: ColorName.blue,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sarabun',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              context
                                  .pushRoute(NotificationRoute(child: student));
                            },
                            icon: Assets.icons.bellRedDot.svg(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                      child: Row(children: [
                        const Text(
                          'Hôm nay 26°C',
                          style: TextStyle(color: ColorName.borderColor),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Assets.icons.weather.svg(),
                      ]),
                    ),
                    HomeNewsCard(lstContent: lstContent),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ListMenuButton(child: student),
                    ),
                    SizedBox(height: 20.h),
                    // const Center(
                    //   child: Text(
                    //     'Chúc bạn một ngày mới nhiều niềm vui',
                    //     style: TextStyle(
                    //       color: ColorName.borderColor,
                    //       fontSize: 12,
                    //       fontFamily: 'Sarabun',
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChildrenSelectionCard extends StatefulWidget {
  final bool isSelected;
  final ChildrenInfoModel child;
  final void Function(ChildrenInfoModel child)? onTap;

  const ChildrenSelectionCard({
    Key? key,
    this.isSelected = false,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  State<ChildrenSelectionCard> createState() => _ChildrenSelectionCardState();
}

class _ChildrenSelectionCardState extends State<ChildrenSelectionCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap?.call(widget.child),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.child.name ?? '',
                style: TextStyle(
                    color: widget.isSelected ? ColorName.blue : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sarabun'),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            SizedBox(width: 8.w),
            widget.isSelected
                ? Assets.icons.checkBoxBlue.svg()
                : Assets.icons.checkBoxEmpty.svg(),
          ],
        ),
      ),
    );
  }
}
