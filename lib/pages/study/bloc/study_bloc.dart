import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/scores/score_model.dart';
import 'package:vschool/commons/repository/score_repository.dart';

part 'study_event.dart';

part 'study_state.dart';

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  final IScoreRepository _scoreRepository;

  StudyBloc({required IScoreRepository scoreRepository})
      : _scoreRepository = scoreRepository,
        super(GetScoresInitial()) {
    on<StudyScoreFetching>(_onStudyScoreFetching);
  }

  FutureOr<void> _onStudyScoreFetching(
      StudyScoreFetching event, Emitter<StudyState> emit) async {
    final result = await _scoreRepository.getScore(
        studentId: event.studentId,
        startStudyYear: event.startStudyYear,
        semester: event.semester);

    result.when(
      success: (success) => emit(GetScoresSuccess(data: result.success?.data)),
      failure: (failure) =>
          emit(GetScoresFailure(mess: result.failure?.message ?? '')),
    );
  }
}
