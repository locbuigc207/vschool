import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  final StreamController<Uri> _deepLinkStreamController =
      StreamController<Uri>.broadcast();
  Stream<Uri> get deepLinkStream => _deepLinkStreamController.stream;

  Future<void> initUniLinks() async {
    // Handle incoming links - deep linking
    try {
      // Get the initial link if the app was launched from a link
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        debugPrint('Initial URI received: $initialLink');
        _handleDeepLink(initialLink);
      }

      // Listen to incoming links while the app is running
      _appLinks.uriLinkStream.listen((Uri uri) {
        debugPrint('URI received while app is running: $uri');
        _handleDeepLink(uri);
      }, onError: (err) {
        debugPrint('Deep link error: $err');
      });
    } catch (e) {
      debugPrint('Failed to initialize deep links: $e');
    }
  }

  void _handleDeepLink(Uri uri) {
    if (uri.scheme == 'vschool' &&
        uri.host == 'payment' &&
        uri.path == '/callback') {
      debugPrint('Payment callback received');
      debugPrint('Query parameters: ${uri.queryParameters}');
      _deepLinkStreamController.add(uri);
    }
  }

  void dispose() {
    _deepLinkStreamController.close();
  }
}
