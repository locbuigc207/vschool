import 'package:auto_route/auto_route.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstRunGuard extends AutoRouteGuard {
  Future<bool> canNavigate(NavigationResolver resolver, StackRouter router) {
    final appBloc = router.navigatorKey.currentContext?.read<AppBloc>();
    final isLoggedIn = appBloc?.state.user != null;
    final targetRoute = resolver.route.name;

    // Nếu đã đăng nhập và đang cố truy cập LoginRoute
    if (isLoggedIn && targetRoute == 'LoginRoute') {
      router.replace(const HomeRoute());
      return Future.value(false);
    }

    // Nếu chưa đăng nhập và đang cố truy cập HomeRoute
    if (!isLoggedIn && targetRoute == 'HomeRoute') {
      router.replace(const LoginRoute());
      return Future.value(false);
    }

    // Cho phép điều hướng trong các trường hợp khác
    return Future.value(true);
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Cho phép điều hướng tiếp tục nếu canNavigate trả về true
    resolver.next();
  }
}
