import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vschool/commons/models/user/user_model.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';
import 'package:vschool/pages/home/home_page.dart';
import 'package:vschool/pages/login/login_page.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool? isLogged;

  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  Future<void> checkLogin() async {
    final SharedPreferences preferences = await _preferences;
    isLogged = preferences.getBool('isLogged');
  }

  @override
  void initState() {
    checkLogin();
    Timer(const Duration(milliseconds: 1000), () async {
      final SharedPreferences preferences = await _preferences;
      var oldAccessToken = preferences.getString("accessToken");
      var oldRefreshToken = preferences.getString('refreshToken');
      if (oldRefreshToken != null) {
        print("old Refresh Token: $oldRefreshToken");
      }
      var parent = preferences.getString("parent");
      if (isLogged == true &&
          oldAccessToken != null &&
          oldRefreshToken != null) {
        final resultRefreshToken = await getIt<IUserRepository>()
            .refreshToken(refreshToken: oldRefreshToken);
        print(resultRefreshToken);
        resultRefreshToken.when(success: (success) {
          preferences.setString("accessToken", success.info ?? '');
        }, failure: (failure) {
          print("refreshToken failed");
        });
        print(parent);
        if (parent != null) {
          UserLoginInfoModel user =
              UserLoginInfoModel.fromJson(jsonDecode(parent));

          context.read<AppBloc>().add(UpdateAppUser(user));
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const LoginPage()));
        }
      } else {
        print(oldRefreshToken);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.images.logo.image(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
