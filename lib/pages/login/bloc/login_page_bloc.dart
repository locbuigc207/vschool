import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vschool/commons/extensions/login_form_validators.dart';
import 'package:vschool/commons/models/user/user_model.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';

part 'login_page_event.dart';

part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState>
    with LoginFormValidators {
  final IUserRepository _userRepository;
  final AppBloc _appBloc;

  LoginPageBloc(
      {required IUserRepository userRepository, required AppBloc appBloc})
      : _userRepository = userRepository,
        _appBloc = appBloc,
        super(LoginProcessing()) {
    on<Login>(_onLogin);
  }

  FutureOr<void> _onLogin(event, emit) async {
    emit(LoginProcessing());

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final deviceInfoPlugin = DeviceInfoPlugin();
    late String? deviceId;
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      deviceId = info.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfoPlugin.iosInfo;
      deviceId = info.identifierForVendor;
    }

    final result = await _userRepository.login(
        username: event.username, password: event.password, deviceId: deviceId);

    await result.when(
      success: (success) async {
        // final currentUserResult = await _userRepository.getCurrentUser(
        //     userId: result.success!.user!.userId);

        preferences.setBool('isLogged', true);

        // currentUserResult.when(
        //   success: (user) async {
        final parent = success.info;

        final String tmp = jsonEncode(parent?.toJson());

        preferences.setString('parent', tmp);

        preferences.setString('accessToken', parent!.token ?? '');
        preferences.setString('refreshToken', parent.refreshToken ?? '');

        print("\nfcm Token Local: ${preferences.getString('fcmToken')}");
        print(preferences.getString('parent').toString());

        _appBloc.add(UpdateAppUser(parent));

        emit(
          LoginSuccess(
              code: result.success!.code,
              mess: result.success!.msg,
              user: result.success!.info!),
        );
        // },
        // failure: (failure) =>
        //       LoginFail(mess: currentUserResult.failure!.message ?? ''),
        // );
      },
      failure: (failure) async {
        preferences.setBool('isLogged', false);

        emit(LoginFail(mess: result.failure!.message ?? ''));
      },
    );
  }
}
