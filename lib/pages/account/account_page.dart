import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/buttons/list_button.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/account/widgets/profile_card.dart';

@RoutePage()
class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? currentVersion;

  @override
  void initState() {
    getCurrentVersion();
    super.initState();
  }

  Future<void> getCurrentVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      currentVersion = packageInfo.version;
    });
  }

  void clearPref() async {
    try {
      // Call logout API
      // ignore: unused_local_variable
      final result = await getIt<IUserRepository>().logout();

      // Clear all SharedPreferences data
      final pref = await SharedPreferences.getInstance();
      await pref.clear(); // This will clear all stored data

      // Navigate to login and clear navigation stack
      if (mounted) {
        context.router.replaceAll([const LoginRoute()]);
      }
    } catch (e) {
      print('Logout error: $e');
      // Even if API call fails, clear local data
      final pref = await SharedPreferences.getInstance();
      await pref.clear();
      if (mounted) {
        context.router.replaceAll([const LoginRoute()]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Tài khoản',
      leading: SizedBox.shrink(),
      child: Stack(
        children: [
          Positioned(
            child: FadeAnimation(
              delay: 0.5,
              child: GradientHeaderContainer(height: 140.h),
            ),
          ),
          SafeArea(
            child: FadeAnimation(
              delay: 1,
              direction: FadeDirection.up,
              child: RoundedTopContainer(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const ProfileCard(),
                      SizedBox(height: 10.h),
                      ListButton(
                        leading: Assets.icons.children.svg(width: 25.r),
                        trailing: const SizedBox.shrink(),
                        title: 'Danh sách học sinh',
                        onTap: () =>
                            context.pushRoute(const ListChildrenRoute()),
                      ),
                      SizedBox(height: 10.h),
                      ListButton(
                        leading: Icon(Icons.password_outlined, size: 25.r),
                        trailing: const SizedBox.shrink(),
                        title: 'Đổi mật khẩu',
                        onTap: () =>
                            context.pushRoute(const ChangePasswordRoute()),
                      ),
                      SizedBox(height: 10.h),
                      ListButton(
                        leading: Icon(Icons.logout_outlined, size: 25.r),
                        trailing: const SizedBox.shrink(),
                        title: 'Đăng xuất',
                        onTap: () {
                          clearPref();
                        },
                      ),
                      SizedBox(height: 10.h),
                      ListButton(
                        leading: Assets.icons.info.svg(height: 20.r),
                        trailing: Text('v$currentVersion'),
                        title: 'Phiên bản ứng dụng',
                        onTap: () {},
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
