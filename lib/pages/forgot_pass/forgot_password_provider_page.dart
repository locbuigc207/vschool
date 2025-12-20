import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/forgot_pass/bloc/forgot_password_bloc.dart';

@RoutePage()
class ForgotPasswordProviderPage extends StatelessWidget {
  const ForgotPasswordProviderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) =>
            ForgotPasswordBloc(userRepository: getIt<IUserRepository>()),
      ),
    ], child: const AutoRouter());
  }
}
