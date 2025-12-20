import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/repository/invoice_repository.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoicePageBloc extends Bloc<InvoicePageEvent, InvoicePageState> {
  final IInvoiceRepository _invoiceRepository;

  InvoicePageBloc({required IInvoiceRepository invoiceRepository})
      : _invoiceRepository = invoiceRepository,
        super(const InvoicePageState(lstInvoice: [])) {
    on<GetAllStudentInvoice>(_onGetAllStudentInvoice);
    // on<GetAllStudentInvoiceByStudentCode>(_onGetAllStudentInvoiceByStudentCode);
  }

  FutureOr<void> _onGetAllStudentInvoice(
      GetAllStudentInvoice event, Emitter<InvoicePageState> emit) async {
    emit(state.copyWith(
      lstInvoice: const [],
      isLoading: true,
      error: null,
    ));

    final result =
        await _invoiceRepository.getInvoiceByChild(studentId: event.studentId);

    result.when(
      success: (success) => emit(state.copyWith(
        lstInvoice: result.success!.newStudentInvoice,
        isRefreshing: false,
        error: null,
        isLoading: false,
      )),
      failure: (failure) => emit(state.copyWith(
        isRefreshing: false,
        error: failure.message,
        isLoading: false,
      )),
    );
  }

  // FutureOr<void> _onGetAllStudentInvoiceByStudentCode(
  //     GetAllStudentInvoiceByStudentCode event,
  //     Emitter<InvoicePageState> emit) async {
  //   emit(state.copyWith(
  //     lstInvoice: const [],
  //     isLoading: true,
  //     error: null,
  //   ));

  //   final result = await _invoiceRepository.getInvoiceByStudentCode(
  //       studentCode: event.studentCode);

  //   result.when(
  //     success: (success) => emit(state.copyWith(
  //       lstInvoice: result.success!.newStudentInvoice,
  //       isRefreshing: false,
  //       error: null,
  //       isLoading: false,
  //     )),
  //     failure: (failure) => emit(state.copyWith(
  //       isRefreshing: false,
  //       error: failure.message,
  //       isLoading: false,
  //     )),
  //   );
  // }
}
