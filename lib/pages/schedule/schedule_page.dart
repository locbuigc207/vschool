import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/schedule/schedule_model.dart';
import 'package:vschool/commons/repository/schedule_repository.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/schedule/bloc/schedule_bloc.dart';
import 'package:vschool/pages/schedule/widget/schedule_table.dart';

@RoutePage()
class SchedulePage extends StatefulWidget {
  final ChildrenInfoModel child;

  const SchedulePage({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<DateTime> weekDates = [];
  late DateTime firstDayOfWeek;
  DateTime _currentDate = DateTime.now();

  List<ScheduleModel> lstData = [];
  List<ScheduleModel> lstDataSang = [];
  List<ScheduleModel> lstDataChieu = [];
  List<ScheduleModel> lstDataToi = [];

  List<String> dayOfWeek = [
    '',
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'CN',
  ];

  void _previousWeek() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 7));
    });
  }

  @override
  void initState() {
    firstDayOfWeek =
        _currentDate.subtract(Duration(days: _currentDate.weekday - 1));

    for (int i = 0; i < 7; i++) {
      DateTime date = firstDayOfWeek.add(Duration(days: i));
      weekDates.add(date);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Thời khóa biểu',
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
                    create: (_) => ScheduleBloc(
                        scheduleRepository: getIt<IScheduleRepository>())
                      ..add(ScheduleFetching(
                          classId: widget.child.classId!,
                          startDate: DateFormat('dd/MM').format(firstDayOfWeek),
                          endDate: DateFormat('dd/MM').format(weekDates.last),
                          studyYear: DateTime.now().year)),
                    child: BlocConsumer<ScheduleBloc, ScheduleState>(
                      listener: (context, state) {
                        if (state is ScheduleFetchInitial) {
                          context.loaderOverlay.show();
                        } else if (state is ScheduleFetchFailure) {
                          context.loaderOverlay.hide();
                          showErrorSnackBBar(
                              context: context, message: state.mess);
                        } else if (state is ScheduleFetchSuccess) {
                          context.loaderOverlay.hide();
                          lstData = state.data ?? [];
                          lstDataSang = lstData
                              .where(
                                  (element) => element.scheduleType == 'SANG')
                              .toList();
                          lstDataChieu = lstData
                              .where(
                                  (element) => element.scheduleType == 'CHIEU')
                              .toList();
                          lstDataToi = lstData
                              .where((element) => element.scheduleType == 'TOI')
                              .toList();
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: ColorName.primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0)),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    onPressed: _previousWeek,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${DateFormat('dd/MM').format(firstDayOfWeek)} - ${DateFormat('dd/MM').format(weekDates.last)}',
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                    onPressed: _nextWeek,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: dayOfWeek.map((day) {
                                return Expanded(
                                  child: Container(
                                    alignment: AlignmentDirectional.center,
                                    height: 40,
                                    child: Text(
                                      day,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: day == 'CN'
                                              ? Colors.red
                                              : ColorName.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            // ListView.separated(
                            //     physics: const BouncingScrollPhysics(),
                            //     shrinkWrap: true,
                            //     itemBuilder: (context, index) {
                            //       final session = lstData[index];
                            //       return ScheduleTable(
                            //           sessionOfDay: session.scheduleType);
                            //     },
                            //     separatorBuilder: (context, index) =>
                            //         const SizedBox.shrink(),
                            //     itemCount: lstData.length),
                            ScheduleTable(
                                sessionOfDay: 'Buổi sáng',
                                lstData: lstDataSang),
                            ScheduleTable(
                                sessionOfDay: 'Buổi chiều',
                                lstData: lstDataChieu),
                            ScheduleTable(
                                sessionOfDay: 'Buổi tối', lstData: lstDataToi),
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
