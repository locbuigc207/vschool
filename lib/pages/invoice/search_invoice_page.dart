import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/repository/invoice_repository.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/buttons/loading_primary_button.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/commons/widgets/text_field/primary_text_field.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';
import 'package:vschool/pages/home/bloc/home_bloc.dart';
import 'package:vschool/pages/invoice/bloc/invoice_bloc.dart';
import 'package:vschool/pages/invoice/bloc/invoice_detail_bloc.dart';
import 'package:vschool/pages/invoice/widget/invoice_detail_card.dart';

@RoutePage()
class SearchInvoicePage extends StatefulWidget {
  const SearchInvoicePage({Key? key}) : super(key: key);

  @override
  State<SearchInvoicePage> createState() => _SearchInvoicePageState();
}

class _SearchInvoicePageState extends State<SearchInvoicePage> {
  late TextEditingController _studentCodeController;
  late RefreshController _refreshController;
  final _scrollController = ScrollController();
  bool _isVisible = true;

  late ChildrenInfoModel child = ChildrenInfoModel();

  List<InvoiceInfoModel> lstInvoicePaid = [];
  List<InvoiceInfoModel> lstInvoiceNotPaid = [];

  List<InvoiceInfoModel> lstSelected = [];

  @override
  void initState() {
    _studentCodeController = TextEditingController(text: '');

    _refreshController = RefreshController(initialRefresh: false);

    // Scroll controller
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Tra cứu hóa đơn',
      child: Stack(
        children: [
          FadeAnimation(
            delay: 0.5,
            child: GradientHeaderContainer(height: 140.h),
          ),
          SafeArea(
            child: FadeAnimation(
              delay: 1,
              child: RoundedTopContainer(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => HomePageBloc(
                            userRepository: getIt<IUserRepository>(),
                            appBloc: getIt<AppBloc>())),
                    BlocProvider(
                        create: (_) => InvoicePageBloc(
                            invoiceRepository: getIt<IInvoiceRepository>())),
                  ],
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<InvoicePageBloc, InvoicePageState>(
                          listener: (context, state) {
                        if (state.isLoading == true) {
                          context.loaderOverlay.show();
                        } else {
                          context.loaderOverlay.hide();
                        }
                      }),
                      BlocListener<HomePageBloc, HomePageState>(
                        listener: (context, state) {
                          if (state is GetChildByCodeFailure) {
                            showErrorSnackBBar(
                                context: context, message: state.mess);
                          } else if (state is GetChildByCodeSuccess) {
                            child = state.child;
                          }
                        },
                      ),
                    ],
                    child: BlocBuilder<InvoicePageBloc, InvoicePageState>(
                      builder: (context, state) {
                        var lstInvoice = state.lstInvoice;

                        lstInvoiceNotPaid = lstInvoice
                            .where((element) => element.status == 0)
                            .toList();

                        lstInvoicePaid = lstInvoice
                            .where((element) => element.status == 1)
                            .toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryTextField(
                              controller: _studentCodeController,
                              labelText: 'Mã học sinh',
                              hintText: 'Nhập mã học sinh',
                            ),
                            SizedBox(height: 15.h),
                            LoadingPrimaryButton(
                              title: 'Tìm kiếm',
                              height: 56.h,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                context.read<HomePageBloc>().add(
                                    GetStudentByCode(
                                        studentCode:
                                            _studentCodeController.text));
                                context.read<InvoicePageBloc>().add(
                                    GetAllStudentInvoiceByStudentCode(
                                        studentCode:
                                            _studentCodeController.text));
                              },
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Chưa đóng (${lstInvoiceNotPaid.length})',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sarabun',
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              width: 76.w,
                              height: 4.h,
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24))),
                            ),
                            SizedBox(height: 36.h),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InvoiceDetailCard(
                                    onTap: (infoModel) {
                                      setState(() {
                                        if (!lstSelected.contains(infoModel)) {
                                          lstSelected.add(infoModel);
                                          context.read<InvoiceDetailBloc>().add(
                                              InvoiceDetailChange(
                                                  lstInvoice: lstSelected));
                                        } else {
                                          lstSelected.remove(infoModel);
                                          context.read<InvoiceDetailBloc>().add(
                                              InvoiceDetailChange(
                                                  lstInvoice: lstSelected));
                                        }
                                      });
                                    },
                                    child: child,
                                    invoice: lstInvoiceNotPaid[index]);
                              },
                              separatorBuilder: (_, __) =>
                                  const SizedBox.shrink(),
                              itemCount: lstInvoiceNotPaid.length,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          lstSelected.isNotEmpty
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      context.pushRoute(InvoicePaymentRoute(
                          child: child, lstInvoice: lstSelected));
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
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
