import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:vschool/commons/api/clients/api_client.dart';
import 'package:vschool/commons/api/dio_di.dart';
import 'package:vschool/commons/repository/admissions_repository.dart';
import 'package:vschool/commons/repository/food_repository.dart';
import 'package:vschool/commons/repository/heath_repository.dart';
import 'package:vschool/commons/repository/invoice_repository.dart';
import 'package:vschool/commons/repository/notification_repository.dart';
import 'package:vschool/commons/repository/payment_method_repository.dart';
import 'package:vschool/commons/repository/report_card_repository.dart';
import 'package:vschool/commons/repository/schedule_repository.dart';
import 'package:vschool/commons/repository/score_repository.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/commons/services/local_file_service/local_file_service.dart';
import 'package:vschool/flavors.dart';
import 'package:dio/dio.dart';
import 'package:vschool/pages/account/pages/change_password/bloc/change_password_bloc.dart';
import 'package:vschool/pages/admissions/bloc/admissions_bloc.dart';
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

import 'pages/account/pages/list_children/bloc/list_children_bloc.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Third-party
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<DeviceInfoPlugin>(DeviceInfoPlugin());

  // Services
  getIt.registerSingleton<ILocalFileService>(LocalFileService());

  // API Client
  getIt.registerSingleton<ApiClient>(ApiClient(
    getIt<Dio>(),
    baseUrl: F.apiUrl,
  ));
  // App
  // Repository
  getIt.registerSingleton<IUserRepository>(
    UserRepository(apiClient: getIt<ApiClient>()),
  );

  getIt.registerSingleton<INotificationRepository>(
      NotificationRepository(apiClient: getIt<ApiClient>()));

  getIt.registerSingleton<IInvoiceRepository>(
      InvoiceRepository(apiClient: getIt<ApiClient>()));

  getIt.registerSingleton<IPaymentMethodRepository>(
      PaymentMethodRepository(apiClient: getIt<ApiClient>()));

  getIt.registerSingleton<IAdmissionsRepository>(
      AdmissionsRepository(apiClient: getIt<ApiClient>()));

  getIt.registerSingleton<IReportCardRepository>(
      ReportCardRepository(apiClient: getIt<ApiClient>()));

  getIt.registerSingleton<IFoodRepository>(
      FoodRepository(apiClient: getIt<ApiClient>()));

  getIt.registerSingleton<IHeathRepository>(
      HeathRepository(apiClient: getIt<ApiClient>()));

  getIt.registerSingleton<IScoreRepository>(
      ScoreRepository(apiClient: getIt<ApiClient>()));

  getIt.registerSingleton<IScheduleRepository>(
      ScheduleRepository(apiClient: getIt<ApiClient>()));

  // Bloc
  getIt.registerSingleton<AppBloc>(AppBloc());

  getIt.registerSingleton<LoginPageBloc>(LoginPageBloc(
      userRepository: getIt<IUserRepository>(), appBloc: getIt<AppBloc>()));

  getIt.registerSingleton<HomePageBloc>(HomePageBloc(
      userRepository: getIt<IUserRepository>(), appBloc: getIt<AppBloc>()));

  getIt.registerSingleton<NotificationPageBloc>(NotificationPageBloc(
      notificationRepository: getIt<INotificationRepository>()));

  getIt.registerSingleton<ForgotPasswordBloc>(
      ForgotPasswordBloc(userRepository: getIt<IUserRepository>()));

  getIt.registerSingleton<InvoicePageBloc>(
      InvoicePageBloc(invoiceRepository: getIt<IInvoiceRepository>()));

  getIt.registerSingleton<InvoiceDetailBloc>(
      InvoiceDetailBloc(invoiceRepository: getIt<IInvoiceRepository>()));

  getIt.registerSingleton<PaymentInvoiceBloc>(PaymentInvoiceBloc(
      paymentMethodRepository: getIt<IPaymentMethodRepository>(),
      localFileService: getIt<ILocalFileService>()));

  getIt.registerSingleton<AdmissionsBloc>(
      AdmissionsBloc(admissionsRepository: getIt<IAdmissionsRepository>()));

  getIt.registerSingleton<FoodMenuBloc>(
      FoodMenuBloc(foodRepository: getIt<IFoodRepository>()));

  getIt.registerSingleton<HeathBloc>(
      HeathBloc(heathRepository: getIt<IHeathRepository>()));

  getIt.registerSingleton<ReportCardBloc>(
      ReportCardBloc(reportCardRepository: getIt<IReportCardRepository>()));

  getIt.registerSingleton<ScheduleBloc>(
      ScheduleBloc(scheduleRepository: getIt<IScheduleRepository>()));

  getIt.registerSingleton<ChangePasswordBloc>(
      ChangePasswordBloc(userRepository: getIt<IUserRepository>()));

  getIt.registerSingleton<ListChildrenBloc>(
      ListChildrenBloc(userRepository: getIt<IUserRepository>()));
}

// ignore: unused_element
class _DioDi extends DioDi {}
