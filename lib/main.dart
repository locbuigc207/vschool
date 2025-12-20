import 'package:vschool/flavors.dart';
import 'package:vschool/pages/app.dart';
import 'package:flutter/widgets.dart';
import 'commons/services/deep_link_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.dev;
  final deepLinkService = DeepLinkService();
  await deepLinkService.initUniLinks();
  startApp();
}
