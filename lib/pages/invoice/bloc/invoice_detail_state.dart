part of 'invoice_detail_bloc.dart';

abstract class InvoiceDetailState extends Equatable {
  const InvoiceDetailState();
}

class InvoiceDetailInitial extends InvoiceDetailState {
  @override
  List<Object?> get props => [];
}

class InvoiceDetailChanged extends InvoiceDetailState {
  final List<InvoiceInfoModel> lstInvoice;

  const InvoiceDetailChanged({required this.lstInvoice});

  @override
  List<Object?> get props => [lstInvoice];
}
