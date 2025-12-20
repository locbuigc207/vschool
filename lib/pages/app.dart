import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:loggy/loggy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vschool/commons/api/bad_certificate_overrides.dart';
import 'package:vschool/commons/api/firebase/firebase_api.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vschool/firebase_options.dart';
import 'package:vschool/flavors.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/account/pages/change_password/bloc/change_password_bloc.dart';
import 'package:vschool/pages/account/pages/list_children/bloc/list_children_bloc.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';
import 'package:vschool/pages/food_menu/bloc/food_menu_bloc.dart';
import 'package:vschool/pages/forgot_pass/bloc/forgot_password_bloc.dart';
import 'package:vschool/pages/heath/bloc/heath_bloc.dart';
import 'package:vschool/pages/home/bloc/home_bloc.dart';
import 'package:vschool/pages/invoice/bloc/invoice_bloc.dart';
import 'package:vschool/pages/invoice/bloc/invoice_detail_bloc.dart';
import 'package:vschool/pages/login/bloc/login_page_bloc.dart';
import 'package:vschool/pages/notification/bloc/notification_page_bloc.dart';
import 'package:vschool/pages/payment_invoice/bloc/payment_invoice_bloc.dart';
import 'package:vschool/pages/report_card/bloc/report_card_bloc.dart';
import 'package:vschool/pages/schedule/bloc/schedule_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vschool/commons/extensions/app_lifecycle_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// Global navigator key để truy cập navigation từ bất kỳ đâu trong app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Router instance cho toàn bộ ứng dụng
final appRouter = AppRouter();

/// Khởi tạo và chạy ứng dụng VSchool
///
/// Thực hiện các bước khởi tạo:
/// - Firebase configuration
/// - Dependency injection
/// - Logging setup
/// - Hydrated bloc storage
void startApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await _initializeFirebase();

  // Khởi tạo dependency injection
  configureDependencies();

  // Cấu hình HTTP overrides cho development
  _configureHttpOverrides();

  // Khởi tạo logging system
  _initializeLogging();

  // Khởi tạo hydrated bloc storage
  await _initializeHydratedBloc();

  // Chạy ứng dụng
  runApp(const App());
}

/// Khởi tạo Firebase với cấu hình phù hợp cho platform
Future<void> _initializeFirebase() async {
  try {
    // Kiểm tra xem Firebase đã được khởi tạo chưa
    if (Firebase.apps.isEmpty) {
      print('Initializing Firebase for: ${DefaultFirebaseOptions.currentPlatform}');
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } else {
      print('Firebase already initialized, using existing app');
    }
    await FireBaseApi().initNotifications();
  } catch (e) {
    print('Firebase initialization error: $e');
    // Nếu có lỗi, thử sử dụng app hiện có
    try {
      await FireBaseApi().initNotifications();
    } catch (e2) {
      print('Failed to initialize notifications: $e2');
    }
  }
}

/// Cấu hình HTTP overrides cho development environment
void _configureHttpOverrides() {
  HttpOverrides.global = BadCertificateOverrides();
}

/// Khởi tạo logging system với pretty printer
void _initializeLogging() {
  Loggy.initLoggy(
    logPrinter: const PrettyDeveloperPrinter(),
  );
}

/// Khởi tạo HydratedBloc storage để persist state
Future<void> _initializeHydratedBloc() async {
  final tempDir = await getTemporaryDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(tempDir.path),
  );
}

/// Widget chính của ứng dụng VSchool
class App extends StatelessWidget with PortraitModeMixin {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) {
        return MaterialApp.router(
          title: 'VSchool',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter.config(),
          builder: (context, child) {
            return _buildAppWithDependencies(child);
          },
        );
      },
    );
  }

  /// Xây dựng app với dependency injection và BlocProvider
  Widget _buildAppWithDependencies(Widget? child) {
    return FutureBuilder(
      future: getIt.allReady(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingScreen();
        }

        return AppLifeCycleManager(
          child: _buildBlocProviders(child),
        );
      },
    );
  }

  /// Màn hình loading khi đang khởi tạo dependencies
  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Xây dựng MultiBlocProvider với tất cả Bloc cần thiết
  Widget _buildBlocProviders(Widget? child) {
    return MultiBlocProvider(
      providers: _getBlocProviders(),
      child: _buildRefreshConfiguration(child),
    );
  }

  /// Danh sách tất cả BlocProvider cần thiết cho ứng dụng
  List<BlocProvider> _getBlocProviders() {
    return [
      BlocProvider.value(value: getIt<AppBloc>()),
      BlocProvider.value(value: getIt<LoginPageBloc>()),
      BlocProvider.value(value: getIt<HomePageBloc>()),
      BlocProvider.value(value: getIt<NotificationPageBloc>()),
      BlocProvider.value(value: getIt<ForgotPasswordBloc>()),
      BlocProvider.value(value: getIt<InvoicePageBloc>()),
      BlocProvider.value(value: getIt<InvoiceDetailBloc>()),
      BlocProvider.value(value: getIt<PaymentInvoiceBloc>()),
      BlocProvider.value(value: getIt<FoodMenuBloc>()),
      BlocProvider.value(value: getIt<HeathBloc>()),
      BlocProvider.value(value: getIt<ReportCardBloc>()),
      BlocProvider.value(value: getIt<ScheduleBloc>()),
      BlocProvider.value(value: getIt<ChangePasswordBloc>()),
      BlocProvider.value(value: getIt<ListChildrenBloc>()),
    ];
  }

  /// Xây dựng RefreshConfiguration với custom headers và footers
  Widget _buildRefreshConfiguration(Widget? child) {
    return RefreshConfiguration(
      headerBuilder: () => _buildRefreshHeader(),
      footerBuilder: () => _buildRefreshFooter(),
      child: _buildGestureDetector(child),
    );
  }

  /// Custom header cho pull-to-refresh
  Widget _buildRefreshHeader() {
    return const ClassicHeader(
      completeText: 'Tải lại thành công',
      refreshingText: 'Đang tải...',
      failedText: 'Tải lại thất bại',
      idleText: 'Kéo xuống để tải lại',
      releaseText: 'Thả để tải lại',
    );
  }

  /// Custom footer cho load-more
  Widget _buildRefreshFooter() {
    return const ClassicFooter(
      noDataText: 'Không có dữ liệu',
      loadingText: 'Đang tải...',
      failedText: 'Tải thêm thất bại',
      idleText: 'Tải thêm',
      canLoadingText: 'Thả để tải thêm',
    );
  }

  /// GestureDetector để ẩn keyboard khi tap outside
  Widget _buildGestureDetector(Widget? child) {
    return LoaderOverlay(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: _buildFlavorBanner(
          child: child ?? const EmptyRouterPage(),
          show: false,
        ),
      ),
    );
  }

  /// Widget banner hiển thị flavor (development/production)
  Widget _buildFlavorBanner({
    required Widget child,
    bool show = true,
  }) {
    if (!show) return child;

    return Banner(
      location: BannerLocation.topStart,
      message: F.name,
      color: Colors.green.withValues(alpha: 0.6),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
        letterSpacing: 1.0,
      ),
      textDirection: TextDirection.ltr,
      child: child,
    );
  }
}

/// Mixin để đảm bảo ứng dụng chỉ chạy ở chế độ portrait
mixin PortraitModeMixin on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return const Scaffold();
  }
}

/// Cấu hình orientation chỉ cho portrait mode
/// Ngăn chặn rotation của màn hình
void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
