import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/repository/score_repository.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/dropdown/primary_dropdown.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';
import 'package:vschool/pages/home/bloc/home_bloc.dart';
import 'package:vschool/pages/study/bloc/study_bloc.dart';
import 'package:vschool/pages/study/widget/score_schedule.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class StudyPages extends StatelessWidget {
  const StudyPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? startStudyYear =
        int.tryParse(DateFormat('yyyy').format(DateTime.now()));

    int semester = 1;

    var child = context.select((HomePageBloc bloc) {
      final state = bloc.state;
      return state is ChildSelectedChanging ? state.child : null;
    });
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Kết quả học tập',
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
                margin: EdgeInsets.only(top: 16.h),
                padding: EdgeInsets.fromLTRB(10.w, 16.h, 10.w, 0),
                child: SingleChildScrollView(
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                          create: (_) => HomePageBloc(
                              userRepository: getIt<IUserRepository>(),
                              appBloc: getIt<AppBloc>())),
                      BlocProvider(
                          create: (_) => StudyBloc(
                              scoreRepository: getIt<IScoreRepository>())),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10.h),
                        PrimaryDropdown<DropdownItem>(
                          hasClearButton: true,
                          label: 'Kỳ học',
                          dropdownHeight: 220.h,
                          items: [
                            DropdownItem(title: 'Học kỳ 1 - 2023', value: '0'),
                            DropdownItem(title: 'Học kỳ 2 - 2023', value: '1'),
                            DropdownItem(title: 'Học kỳ 1 - 2022', value: '2'),
                            DropdownItem(title: 'Học kỳ 2 - 2022', value: '3'),
                          ],
                          onChanged: (item) {
                            if (item?.value == '0') {
                              startStudyYear = 2023;
                              semester = 1;
                            } else if (item?.value == '1') {
                              startStudyYear = 2023;
                              semester = 2;
                            } else if (item?.value == '2') {
                              startStudyYear = 2022;
                              semester = 1;
                            } else if (item?.value == '3') {
                              startStudyYear = 2022;
                              semester = 2;
                            }
                          },
                          suffix: Assets.icons.chevronDown.svg(),
                        ),
                        SizedBox(height: 20.h),
                        ScoreSchedule(
                            child: child,
                            startStudyYear: startStudyYear,
                            semester: semester),
                      ],
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
