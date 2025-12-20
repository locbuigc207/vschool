import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/injections.dart';

class AppLifeCycleManager extends StatefulWidget {
  final Widget child;

  const AppLifeCycleManager({
    super.key,
    required this.child,
  });

  @override
  State<AppLifeCycleManager> createState() => _AppLifeCycleManagerState();
}

class _AppLifeCycleManagerState extends State<AppLifeCycleManager>
    with WidgetsBindingObserver {
  // ignore: unused_field
  final IUserRepository _userRepository = getIt<IUserRepository>();

  @override
  void initState() {
    super.initState();

    // Register this object as an observer for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _performLogout(BuildContext? contextForNavigation) async {
    try {
      // Call logout API
      // ignore: unused_local_variable
      final result = await getIt<IUserRepository>().logout();

      // Clear all SharedPreferences data
      final pref = await SharedPreferences.getInstance();
      await pref.clear(); // This will clear all stored data

      // Navigate to login if context is available
      if (contextForNavigation != null && contextForNavigation.mounted) {
        contextForNavigation.router.replaceAll([const LoginRoute()]);
      }
    } catch (e) {
      print('Logout error: $e');
      // Even if API call fails, clear local data
      final pref = await SharedPreferences.getInstance();
      await pref.clear();

      // Navigate to login if context is available
      if (contextForNavigation != null && contextForNavigation.mounted) {
        contextForNavigation.router.replaceAll([const LoginRoute()]);
      }
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
        // App is in the background and detached - perform logout
        await _performLogout(null); // No context available for navigation
        break;
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      default:
        // Do nothing for other states as requested
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    // Unregister from lifecycle notifications
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
