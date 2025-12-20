import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/scores/score_model.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/pages/study/bloc/study_bloc.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/commons/repository/score_repository.dart';

class ScoreSchedule extends StatefulWidget {
  final ChildrenInfoModel? child;
  final int? startStudyYear;
  final int? semester;

  const ScoreSchedule(
      {Key? key, this.child, this.startStudyYear, this.semester})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScoreScheduleState();
}

class _ScoreScheduleState extends State<ScoreSchedule> {
  List<String> header = [
    'STT',
    'Tên môn học',
    'Điểm tổng kết',
    'Ghi chú',
  ];

  List<ScoreModel> lst = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudyBloc(
        scoreRepository: getIt<IScoreRepository>(),
      )..add(StudyScoreFetching(
          studentId: widget.child?.studentId ?? 0,
          startStudyYear: widget.startStudyYear!,
          semester: widget.semester!)),
      child: BlocConsumer<StudyBloc, StudyState>(
      listener: (context, state) {
        if (state is GetScoresInitial) {
          context.loaderOverlay.show();
        } else if (state is GetScoresFailure) {
          context.loaderOverlay.hide();
          showErrorSnackBBar(context: context, message: state.mess);
        } else if (state is GetScoresSuccess) {
          context.loaderOverlay.hide();
          lst = state.data ?? [];
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 40.h,
                decoration: const BoxDecoration(
                  color: ColorName.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40.w,
                      child: Center(
                        child: Text(
                          header[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140.w,
                      child: Center(
                        child: Text(
                          header[1],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Center(
                        child: Text(
                          header[2],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70.w,
                      child: Center(
                        child: Text(
                          header[3],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              lst.isEmpty
                  ? Column(
                      children: [
                        SizedBox(height: 250.h),
                        const Text('Không có dữ liệu'),
                      ],
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final score = lst[index];
                        return Padding(
                            padding: EdgeInsets.fromLTRB(
                              16.w,
                              index == 0 ? 24.h : 0.h,
                              16.w,
                              index == lst.length - 1 ? 80.h : 0.h,
                            ),
                            child: ScoreRow(
                              stt: index.toString(),
                              nameSubject: score.subjectName ?? '',
                              score: score.scoreNumber.toString(),
                              note: 'Giỏi',
                            ));
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 24.h),
                      itemCount: lst.length),
            ],
          ),
        );
      },
        ),
    );
  }
}

class ScoreRow extends StatelessWidget {
  final String stt;
  final String nameSubject;
  final String? score;
  final String? note;

  const ScoreRow(
      {Key? key,
      required this.stt,
      required this.nameSubject,
      this.score,
      this.note})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 10.w,
          child: Center(
            child: Text(
              stt,
            ),
          ),
        ),
        SizedBox(
          width: 160.w,
          child: Center(
            child: Text(
              nameSubject,
            ),
          ),
        ),
        SizedBox(
          width: 80.w,
          child: Center(
            child: Text(
              score ?? '',
            ),
          ),
        ),
        SizedBox(
          width: 73.w,
          child: Center(
            child: Text(
              note ?? '',
            ),
          ),
        ),
      ],
    );
  }
}
