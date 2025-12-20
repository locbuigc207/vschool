import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/repository/invoice_repository.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';
import 'package:vschool/pages/home/bloc/home_bloc.dart';
import 'package:vschool/pages/invoice/bloc/invoice_bloc.dart';
import 'package:vschool/pages/invoice/bloc/invoice_detail_bloc.dart';
import 'package:vschool/pages/invoice/widget/invoice_detail_card.dart';
import 'package:vschool/pages/notification/widget/notification_shimmer_loading.dart';
import 'package:vschool/commons/extensions/number_ext.dart';

@RoutePage()
class QRCodePage extends StatefulWidget {
  const QRCodePage({Key? key}) : super(key: key);

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  List<InvoiceInfoModel> lstInvoicePaid = [];
  List<InvoiceInfoModel> lstInvoiceNotPaid = [];
  List<InvoiceInfoModel> lstSelected = [];
  late int _studentId = 0;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    getStudentId();
  }

  void getStudentId() async {
    SharedPreferences preferences = await _prefs;
    final studentId = preferences.getInt('studentId');
    if (studentId != null) {
      setState(() {
        _studentId = studentId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Thông tin hóa đơn',
      hasBack: false,
      child: Stack(
        children: [
          FadeAnimation(
            delay: 0.5,
            child: GradientHeaderContainer(height: 140.h),
          ),
          SafeArea(
            child: FadeAnimation(
              delay: 1,
              direction: FadeDirection.up,
              child: RoundedTopContainer(
                margin: EdgeInsets.only(top: 16.h, bottom: 30.h),
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                child: _studentId > 0 
                    ? MultiBlocProvider(
                        providers: [
                          BlocProvider(
                              create: (_) => InvoicePageBloc(
                                  invoiceRepository: getIt<IInvoiceRepository>())
                                ..add(GetAllStudentInvoice(studentId: _studentId))),
                          BlocProvider(
                              create: (_) => InvoiceDetailBloc(
                                  invoiceRepository: getIt<IInvoiceRepository>())),
                          BlocProvider(
                              create: (_) => HomePageBloc(
                                  userRepository: getIt<IUserRepository>(),
                                  appBloc: getIt<AppBloc>())..add(const GetAllChildren())),
                        ],
                        child: BlocBuilder<HomePageBloc, HomePageState>(
                          builder: (context, homeState) {
                            var child = (homeState is GetAllChildrenSuccess && homeState.children.isNotEmpty) 
                                ? homeState.children.first 
                                : null;
                            
                            return BlocConsumer<InvoicePageBloc, InvoicePageState>(
                              listener: (context, state) {
                                if (state.isLoading == true) {
                                  // Không cần gọi lại event ở đây
                                }
                              },
                              builder: (context, state) {
                                // Lấy dữ liệu từ state
                                var lstInvoice = state.lstInvoice;
                                lstInvoiceNotPaid = lstInvoice.where((element) => element.status == 0).toList();
                                lstInvoicePaid = lstInvoice.where((element) => element.status == 1).toList();
                                
                                return lstInvoice.isEmpty
                                    ? const NotificationShimmerLoading()
                                    : SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Thông tin học sinh
                                            if (child != null) ...[
                                              const Text(
                                                'Thông tin học sinh',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Sarabun',
                                                ),
                                              ),
                                              SizedBox(height: 20.h),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Tên học sinh:',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Sarabun',
                                                      color: ColorName.borderColor,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    child.name ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Sarabun',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10.h),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Lớp:',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Sarabun',
                                                      color: ColorName.borderColor,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    child.className ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Sarabun',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20.h),
                                              const Divider(),
                                              SizedBox(height: 20.h),
                                            ],
                                            
                                            // Hóa đơn chưa đóng
                                            Text(
                                              'Hóa đơn chưa đóng (${lstInvoiceNotPaid.length})',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Sarabun',
                                              ),
                                            ),
                                            SizedBox(height: 20.h),
                                            if (lstInvoiceNotPaid.isNotEmpty) ...[
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  final invoice = lstInvoiceNotPaid[index];
                                                  return Container(
                                                    padding: EdgeInsets.all(16.w),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.grey.shade300),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Checkbox(
                                                          value: lstSelected.contains(invoice),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              if (value == true) {
                                                                lstSelected.add(invoice);
                                                              } else {
                                                                lstSelected.remove(invoice);
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                invoice.content ?? '',
                                                                style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: 'Sarabun',
                                                                ),
                                                              ),
                                                              SizedBox(height: 8.h),
                                                              Text(
                                                                'Số tiền: ${invoice.cost?.formatCurrency(symbol: '₫') ?? '0₫'}',
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors.grey,
                                                                  fontFamily: 'Sarabun',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                                                itemCount: lstInvoiceNotPaid.length,
                                              ),
                                              SizedBox(height: 20.h),
                                            ],
                                            
                                            // Hóa đơn đã đóng
                                            if (lstInvoicePaid.isNotEmpty) ...[
                                              Text(
                                                'Hóa đơn đã đóng (${lstInvoicePaid.length})',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Sarabun',
                                                ),
                                              ),
                                              SizedBox(height: 20.h),
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  final invoice = lstInvoicePaid[index];
                                                  return Container(
                                                    padding: EdgeInsets.all(16.w),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.green.shade300),
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: Colors.green.shade50,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.check_circle, color: Colors.green, size: 24),
                                                        SizedBox(width: 12.w),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                invoice.content ?? '',
                                                                style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: 'Sarabun',
                                                                ),
                                                              ),
                                                              SizedBox(height: 8.h),
                                                              Text(
                                                                'Số tiền: ${invoice.cost?.formatCurrency(symbol: '₫') ?? '0₫'}',
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors.grey,
                                                                  fontFamily: 'Sarabun',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                                                itemCount: lstInvoicePaid.length,
                                              ),
                                            ],
                                            
                                            // Nút thanh toán
                                            if (lstSelected.isNotEmpty && child != null) ...[
                                              SizedBox(height: 30.h),
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: InkWell(
                                                  onTap: () {
                                                    context.pushRoute(
                                                        InvoicePaymentRoute(
                                                            child: child!,
                                                            lstInvoice: lstSelected));
                                                  },
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(
                                                            top: BorderSide(
                                                          color: ColorName.borderColor,
                                                          width: 0.5,
                                                        ))),
                                                    height: 60.h,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: 30.w),
                                                        Text(
                                                          '(${lstSelected.length}) Thanh toán',
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'Montserrat',
                                                            color: ColorName.blue,
                                                          ),
                                                        ),
                                                        SizedBox(width: 14.w),
                                                        Assets.icons.wallet.svg(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                              },
                            );
                          },
                        ),
                      )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Đang tải thông tin học sinh...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Sarabun',
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
