import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/heath/heath_model.dart';
import 'package:vschool/commons/repository/heath_repository.dart';

part 'heath_event.dart';

part 'heath_state.dart';

class HeathBloc extends Bloc<HeathEvent, HeathState> {
  final IHeathRepository _heathRepository;

  HeathBloc({required IHeathRepository heathRepository})
      : _heathRepository = heathRepository,
        super(HeathFetching()) {
    on<GetHeathInfo>(_onGetHeathInfo);
  }

  FutureOr<void> _onGetHeathInfo(
      GetHeathInfo event, Emitter<HeathState> emit) async {
    final result =
        await _heathRepository.getHeathInfo(studentId: event.studentId);

    result.when(
      success: (success) =>
          emit(HeathFetchSuccess(heathInfo: result.success?.data)),
      failure: (failure) =>
          emit(HeathFetchFailure(mess: result.failure?.message ?? '')),
    );
  }
}
