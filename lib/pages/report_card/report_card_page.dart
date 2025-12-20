import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:text_area/text_area.dart';
import 'package:vschool/commons/models/childs/children_model.dart';

import 'package:vschool/commons/repository/report_card_repository.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/buttons/primary_button.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/report_card/bloc/report_card_bloc.dart';

@RoutePage()
class ReportCardPage extends StatefulWidget {
  final ChildrenInfoModel child;

  const ReportCardPage({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReportCardPageState();
}

class _ReportCardPageState extends State<ReportCardPage> {
  late TextEditingController _teacherCommentController =
      TextEditingController();
  late TextEditingController myTextController = TextEditingController();
  var reasonValidation = true;

  @override
  void initState() {
    super.initState();
    _teacherCommentController = TextEditingController(text: '');
    myTextController.addListener(() {
      setState(() {
        reasonValidation = myTextController.text.isEmpty;
        myTextController.text = 'Không có dữ liệu';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Sổ liên lạc',
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
                padding: EdgeInsets.fromLTRB(10.w, 16.h, 10.w, 2.h),
                child: SingleChildScrollView(
                  child: BlocProvider(
                    create: (_) => ReportCardBloc(
                        reportCardRepository: getIt<IReportCardRepository>())
                      ..add(GetReportCard(studentId: widget.child.studentId!)),
                    child: BlocConsumer<ReportCardBloc, ReportCardState>(
                      listener: (context, state) {
                        if (state is ReportCardInit) {
                          context.loaderOverlay.show();
                        } else if (state is GetReportCardFailure) {
                          context.loaderOverlay.hide();
                          showErrorSnackBBar(
                              context: context, message: state.mess);
                        } else if (state is GetReportCardSuccess) {
                          context.loaderOverlay.hide();
                          _teacherCommentController.text =
                              state.teacherComment ?? '';
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            const Text(
                              'Nhận xét của giáo viên',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 10.h),
                            TextArea(
                              borderRadius: 10,
                              borderColor: const Color(0xFFCFD6FF),
                              textEditingController: _teacherCommentController,
                              validation: reasonValidation,
                            ),
                            SizedBox(height: 20.h),
                            const Text(
                              'Ý kiến của phụ huynh học sinh',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 10.h),
                            TextArea(
                              borderRadius: 10,
                              borderColor: const Color(0xFFCFD6FF),
                              textEditingController: myTextController,
                              validation: reasonValidation,
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: double.infinity,
                              child: PrimaryButton(
                                enabled:
                                    _teacherCommentController.text.isNotEmpty &&
                                        myTextController.text.isNotEmpty,
                                title: 'Gửi',
                                onTap: () {
                                  context.read<ReportCardBloc>().add(
                                      SubmitReportCard(
                                          studentId: widget.child.studentId!,
                                          teacherComment:
                                              _teacherCommentController.text,
                                          parentComment:
                                              myTextController.text));
                                },
                              ),
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
        ],
      ),
    );
  }
}
