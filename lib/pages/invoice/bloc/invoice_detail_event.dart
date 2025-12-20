part of 'invoice_detail_bloc.dart';

abstract class InvoiceDetailEvent extends Equatable {
  const InvoiceDetailEvent();
}

class InvoiceDetailChange extends InvoiceDetailEvent {
  final List<InvoiceInfoModel> lstInvoice;

  const InvoiceDetailChange({required this.lstInvoice});

  @override
  List<Object?> get props => [];
}
