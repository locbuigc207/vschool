import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vschool/pages/app.dart';

class FireBaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    final fcmToken = await _firebaseMessaging.getToken();
    final SharedPreferences preferences = await _preferences;

    print('fcmToken: $fcmToken');
    preferences.setString('fcmToken', fcmToken.toString());

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await initPushNotifications();
  }

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
    navigatorKey.currentState?.pushNamed('/home', arguments: message);
    navigatorKey.currentState?.pushNamed('/invoice', arguments: message);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // ignore: unused_local_variable
      // ignore: unused_local_variable
      RemoteNotification notification = message.notification!;
      // ignore: unused_local_variable
      AndroidNotification androidNotification = message.notification!.android!;
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
