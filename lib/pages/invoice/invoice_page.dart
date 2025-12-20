import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/repository/invoice_repository.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/invoice/bloc/invoice_bloc.dart';
import 'package:vschool/pages/invoice/widget/invoice_filter_card.dart';
import 'package:vschool/pages/notification/widget/notification_shimmer_loading.dart';
import 'package:intl/intl.dart';
import 'package:vschool/pages/invoice/empty_invoice_page.dart';

@RoutePage()
class InvoicePage extends StatefulWidget {
  final ChildrenInfoModel childId;

  const InvoicePage({Key? key, required this.childId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late RefreshController _refreshController;
  final _scrollController = ScrollController();
  bool _isVisible = true;

  bool _isSelected1 = true;
  bool _isSelected2 = false;
  bool _isSelected3 = false;

  late List<ChildrenInfoModel> lstChildren = [];

  @override
  void initState() {
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
      title: 'Tất cả hóa đơn gần nhất',
      leading: BackButton(
        onPressed: () => Navigator.of(context).pop(),
      ),
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
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => InvoicePageBloc(
                            invoiceRepository: getIt<IInvoiceRepository>())
                          ..add(GetAllStudentInvoice(
                              studentId: widget.childId.studentId!))),
                  ],
                  child: BlocConsumer<InvoicePageBloc, InvoicePageState>(
                    listener: (context, state) {
                      final error = state.error;

                      if (error == null) {
                        _refreshController.refreshCompleted();
                        _refreshController.loadComplete();
                      } else {
                        _refreshController.refreshFailed();
                        _refreshController.loadFailed();
                      }
                    },
                    builder: (context, state) {
                      final error = state.error;

                      if (state.isLoading || state.isRefreshing) {
                        return const NotificationShimmerLoading();
                      } else if (error != null && state.lstInvoice.isEmpty) {
                        return const EmptyInvoicePage();
                      }
                      final lstInvoice = state.lstInvoice;
                      return state.lstInvoice.isEmpty
                          ? const EmptyInvoicePage()
                          : SmartRefresher(
                              controller: _refreshController,
                              physics: const BouncingScrollPhysics(),
                              enablePullDown: true,
                              enablePullUp: true,
                              onRefresh: () => context
                                  .read<InvoicePageBloc>()
                                  .add(GetAllStudentInvoice(
                                      studentId: widget.childId.studentId!)),
                              onLoading: () => context
                                  .read<InvoicePageBloc>()
                                  .add(GetAllStudentInvoice(
                                      studentId: widget.childId.studentId!)),
                              child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final invoice = lstInvoice[index];
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        16.w,
                                        index == 0 ? 60.h : 0.h,
                                        16.w,
                                        index == lstInvoice.length - 1
                                            ? 80.h
                                            : 0.h,
                                      ),
                                      child: InvoiceCard(
                                        content: invoice.content ?? '',
                                        studentName: widget.childId.name!,
                                        invoiceInfo: invoice,
                                        onTap: (invoiceInfo) => context
                                            .pushRoute(InvoiceDetailRoute(
                                                child: widget.childId)),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 24.h),
                                  itemCount: lstInvoice.length),
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 95.h,
            left: 10.w,
            child: TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  context: context,
                  builder: (contextSheet) {
                    return Container(
                      height: 220.h,
                      padding: EdgeInsets.fromLTRB(30.w, 20.h, 16.w, 20.h),
                      child: Scaffold(
                          resizeToAvoidBottomInset: false,
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Chọn theo năm',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sarabun',
                                ),
                              ),
                              SizedBox(height: 30.h),
                              InvoiceFilterCard(
                                isSelected: _isSelected1,
                                invoiceFilter: 'Chọn tất cả',
                                onTap: (infoModel) {
                                  setState(() {
                                    _isSelected1 = true;
                                    _isSelected2 = false;
                                    _isSelected3 = false;
                                  });
                                  Navigator.pop(contextSheet);
                                },
                              ),
                              SizedBox(height: 10.h),
                              InvoiceFilterCard(
                                isSelected: _isSelected2,
                                invoiceFilter: 'Năm học 2022-2023',
                                onTap: (infoModel) {
                                  setState(() {
                                    _isSelected1 = false;
                                    _isSelected2 = true;
                                    _isSelected3 = false;
                                  });
                                  Navigator.pop(contextSheet);
                                },
                              ),
                              SizedBox(height: 10.h),
                              InvoiceFilterCard(
                                isSelected: _isSelected3,
                                invoiceFilter: 'Năm học 2023-2024',
                                onTap: (infoModel) {
                                  setState(() {
                                    _isSelected1 = false;
                                    _isSelected2 = false;
                                    _isSelected3 = true;
                                  });
                                  Navigator.pop(contextSheet);
                                },
                              ),
                            ],
                          )),
                    );
                  },
                );
              },
              icon: const Icon(Icons.filter_alt_rounded, color: Colors.black),
              label: const Text(
                'Bộ lọc',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Sarabun',
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  final String content;
  final String studentName;
  final InvoiceInfoModel invoiceInfo;
  final void Function(InvoiceInfoModel invoiceInfo) onTap;

  const InvoiceCard({
    Key? key,
    required this.content,
    required this.studentName,
    required this.invoiceInfo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(invoiceInfo),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
            border: Border.all(color: ColorName.borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Assets.icons.aBrown.svg(),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Sarabun',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    studentName,
                    style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Trân trọng thông báo quý phụ huynh của cháu $studentName',
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Sarabun',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    invoiceInfo.paymentDate != null
                        ? DateFormat('HH:mm dd/MM/yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                invoiceInfo.paymentDate ?? 0))
                        : '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
