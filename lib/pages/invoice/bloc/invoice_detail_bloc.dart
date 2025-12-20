import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/repository/invoice_repository.dart';

part 'invoice_detail_event.dart';

part 'invoice_detail_state.dart';

class InvoiceDetailBloc extends Bloc<InvoiceDetailEvent, InvoiceDetailState> {
  // ignore: unused_field
  final IInvoiceRepository _invoiceRepository;

  InvoiceDetailBloc({required IInvoiceRepository invoiceRepository})
      : _invoiceRepository = invoiceRepository,
        super(InvoiceDetailInitial()) {
    on<InvoiceDetailChange>(_onInvoiceDetailChange);
  }

  FutureOr<void> _onInvoiceDetailChange(
      InvoiceDetailChange event, Emitter<InvoiceDetailState> emit) {
    emit(InvoiceDetailChanged(lstInvoice: event.lstInvoice));
  }
}
