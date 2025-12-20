import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/models/user/user_model.dart';
import 'package:vschool/commons/widgets/card/avatar_widget.dart';
import 'package:vschool/commons/widgets/card/shadow_card.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileCardState();
}

class ProfileCardState extends State<ProfileCard> {
  late UserLoginInfoModel? parent;

  @override
  void initState() {
    parent = context.read<AppBloc>().state.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ShadowCard(
      shadowOpacity: 0.2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 24.h),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AvatarWidget(
                        height: 100.r,
                        width: 100.r,
                        gender: parent?.gender,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Text(
                  //   parent?.name ?? 'N/A',
                  //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  // ),
                  // SizedBox(height: 8.h),
                  Text(
                    parent?.phoneNumber ?? '',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
