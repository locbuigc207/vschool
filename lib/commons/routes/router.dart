import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/models/notification/notification_model.dart';
import 'package:vschool/pages/account/account_page.dart';
import 'package:vschool/pages/account/pages/change_password/change_password_page.dart';
import 'package:vschool/pages/account/pages/list_children/children_detail_page.dart';
import 'package:vschool/pages/account/pages/list_children/list_children_page.dart';
import 'package:vschool/pages/admissions/admissions_page.dart';
import 'package:vschool/pages/food_menu/food_menu_page.dart';
import 'package:vschool/pages/forgot_pass/forgot_password_page.dart';
import 'package:vschool/pages/forgot_pass/forgot_password_provider_page.dart';
import 'package:vschool/pages/forgot_pass/pages/forgot_password_new_password_page.dart';
import 'package:vschool/pages/forgot_pass/pages/forgot_password_otp_page.dart';
import 'package:vschool/pages/heath/health_page.dart';
import 'package:vschool/pages/home/home_page.dart';
import 'package:vschool/pages/home/home_page_provider.dart';
import 'package:vschool/pages/home/pages/home_base_page.dart';
import 'package:vschool/pages/invoice/invoice_page.dart';
import 'package:vschool/pages/invoice/pages/invoice_detail_page.dart';
import 'package:vschool/pages/invoice/pages/invoice_info_detail_page.dart';
import 'package:vschool/pages/invoice/search_invoice_page.dart';
import 'package:vschool/pages/notification/pages/notification_detail_page.dart';
import 'package:vschool/pages/payment_invoice/invoice_payment_page.dart';
import 'package:vschool/pages/login/login_page.dart';
import 'package:vschool/pages/notification/notification_page.dart';
import 'package:vschool/pages/onboarding/onboarding_page.dart';
import 'package:vschool/pages/payment_invoice/pages/payment_by_bank_page.dart';
import 'package:vschool/pages/payment_invoice/pages/payment_by_qr_code_page.dart';
import 'package:vschool/pages/payment_invoice/pages/payment_method_page.dart';
import 'package:vschool/pages/qr_code/qr_code_page.dart';
import 'package:vschool/pages/report_card/report_card_page.dart';
import 'package:vschool/pages/schedule/schedule_page.dart';
import 'package:vschool/pages/mail/mail_page.dart';
import 'package:vschool/pages/study/study_pages.dart';
import 'package:vschool/pages/invoice/empty_invoice_page.dart';

part 'router.gr.dart';

/// AppRouter - Quản lý tất cả routes trong ứng dụng VSchool
/// Sử dụng auto_route để tự động generate route code
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
        // ===== AUTHENTICATION ROUTES =====
        ..._authRoutes,

        // ===== MAIN APP ROUTES =====
        ..._mainAppRoutes,

        // ===== FEATURE ROUTES =====
        ..._featureRoutes,

        // ===== PAYMENT ROUTES =====
        ..._paymentRoutes,

        // ===== ACCOUNT ROUTES =====
        ..._accountRoutes,
      ];

  /// Routes liên quan đến xác thực (đăng nhập, quên mật khẩu, onboarding)
  List<AutoRoute> get _authRoutes => [
        AutoRoute(
          path: '/onboarding',
          page: OnboardingRoute.page,
        ),
        AutoRoute(
          path: '/login',
          page: LoginRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: '/forgot-password',
          page: ForgotPasswordProviderRoute.page,
          children: [
            AutoRoute(
              path: '',
              page: ForgotPassRoute.page,
            ),
            AutoRoute(
              path: 'otp',
              page: ForgotPasswordOtpRoute.page,
            ),
            AutoRoute(
              path: 'new-password',
              page: ForgotPassNewPassRoute.page,
            ),
          ],
        ),
      ];

  /// Routes chính của ứng dụng (home, navigation)
  List<AutoRoute> get _mainAppRoutes => [
        AutoRoute(
          path: '/home',
          page: HomeRouteProviderRoute.page,
          children: [
            AutoRoute(
              path: '',
              page: HomeRoute.page,
              children: [
                AutoRoute(
                  path: '',
                  page: HomeBaseRoute.page,
                )
              ],
            ),
          ],
        ),
      ];

  /// Routes cho các tính năng chính của ứng dụng
  List<AutoRoute> get _featureRoutes => [
        // Notification routes
        AutoRoute(
          path: '/notification',
          page: NotificationRoute.page,
        ),
        AutoRoute(
          path: '/notification-detail',
          page: NotificationDetailRoute.page,
        ),

        // Invoice routes
        AutoRoute(
          path: '/invoice',
          page: InvoiceRoute.page,
        ),
        AutoRoute(
          path: '/invoice-detail',
          page: InvoiceDetailRoute.page,
        ),
        AutoRoute(
          path: '/invoice_info_detail',
          page: InvoiceInfoDetailRoute.page,
        ),
        AutoRoute(
          path: '/search-invoice',
          page: SearchInvoiceRoute.page,
        ),
        AutoRoute(
          path: '/empty-invoice',
          page: EmptyInvoiceRoute.page,
        ),

        // Academic routes
        AutoRoute(
          path: '/schedule',
          page: ScheduleRoute.page,
        ),
        AutoRoute(
          path: '/admissions',
          page: AdmissionsRoute.page,
        ),
        AutoRoute(
          path: '/heath',
          page: HeathRoute.page,
        ),
        AutoRoute(
          path: '/food',
          page: FoodMenuRoute.page,
        ),
        AutoRoute(
          path: '/report',
          page: ReportCardRoute.page,
        ),
        AutoRoute(
          path: '/study',
          page: StudyRoutes.page,
        ),

        // Other features
        AutoRoute(
          path: '/qrcode',
          page: QRCodeRoute.page,
        ),
        AutoRoute(
          path: '/mail',
          page: MailRoute.page,
        ),
      ];

  /// Routes liên quan đến thanh toán
  List<AutoRoute> get _paymentRoutes => [
        AutoRoute(
          path: '/payment-invoice',
          page: InvoicePaymentRoute.page,
        ),
        AutoRoute(
          path: '/payment-method',
          page: PaymentMethodRoute.page,
        ),
        AutoRoute(
          path: '/payment_by_bank',
          page: PaymentByBankRoute.page,
        ),
        AutoRoute(
          path: '/payment_by_qr_code',
          page: PaymentByQRCodeRoute.page,
        ),
      ];

  /// Routes liên quan đến tài khoản người dùng
  List<AutoRoute> get _accountRoutes => [
        AutoRoute(
          path: '/account',
          page: AccountRoute.page,
        ),
        AutoRoute(
          path: '/change-password',
          page: ChangePasswordRoute.page,
        ),
        AutoRoute(
          path: '/list-children',
          page: ListChildrenRoute.page,
        ),
        AutoRoute(
          path: '/children-detail',
          page: ChildrenDetailRoute.page,
        ),
      ];
}

/// EmptyRouterPage - Widget placeholder cho router
class EmptyRouterPage extends AutoRouter {
  const EmptyRouterPage({super.key});
}
