import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';
import 'package:vschool/pages/home/bloc/home_bloc.dart';
import 'package:vschool/pages/login/bloc/login_page_bloc.dart';

@RoutePage()
class HomePageProviderPage extends StatelessWidget {
  const HomePageProviderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => HomePageBloc(
            userRepository: getIt<IUserRepository>(),
            appBloc: getIt<AppBloc>()),
      ),
      BlocProvider(
        create: (context) => AppBloc(),
      ),
      BlocProvider(
          create: (_) => LoginPageBloc(
              userRepository: getIt<IUserRepository>(),
              appBloc: getIt<AppBloc>())),
    ], child: const AutoRouter());
  }
}
