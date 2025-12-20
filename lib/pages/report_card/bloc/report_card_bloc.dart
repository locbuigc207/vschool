import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/report_card/report_card_model.dart';
import 'package:vschool/commons/repository/report_card_repository.dart';

part 'report_card_event.dart';

part 'report_card_state.dart';

class ReportCardBloc extends Bloc<ReportCardEvent, ReportCardState> {
  final IReportCardRepository _reportCardRepository;

  ReportCardBloc({required IReportCardRepository reportCardRepository})
      : _reportCardRepository = reportCardRepository,
        super(ReportCardInit()) {
    on<GetReportCard>(_onGetReportCard);
    on<SubmitReportCard>(_onSubmitReportCard);
  }

  FutureOr<void> _onGetReportCard(
      GetReportCard event, Emitter<ReportCardState> emit) async {
    final result =
        await _reportCardRepository.getReportCard(studentId: event.studentId);

    result.when(
      success: (success) => emit(GetReportCardSuccess(
          teacherComment: result.success?.data?.teacherComment)),
      failure: (failure) =>
          emit(GetReportCardFailure(mess: result.failure?.message ?? '')),
    );
  }

  FutureOr<void> _onSubmitReportCard(
      SubmitReportCard event, Emitter<ReportCardState> emit) async {
    final request = ReportCardModel(
        studentId: event.studentId,
        teacherComment: event.teacherComment,
        parentComment: event.parentComment);

    final result = await _reportCardRepository.saveReportCard(request: request);

    result.when(
      success: (success) =>
          emit(ReportCardSubmittedSuccess(mess: result.success!.message)),
      failure: (failure) =>
          emit(ReportCardSummitedFailure(mess: result.failure?.message ?? '')),
    );
  }
}
