part of 'invoice_bloc.dart';

class InvoicePageState extends Equatable {
  final List<InvoiceInfoModel> lstInvoice;
  final String? error;
  final bool isLoading;
  final bool isRefreshing;

  const InvoicePageState({
    required this.lstInvoice,
    this.error,
    this.isLoading = false,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [lstInvoice, error, isLoading, isRefreshing];

  InvoicePageState copyWith({
    List<InvoiceInfoModel>? lstInvoice,
    String? error,
    bool? isLoading,
    bool? isRefreshing,
  }) =>
      InvoicePageState(
        lstInvoice: lstInvoice ?? this.lstInvoice,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        isRefreshing: isRefreshing ?? this.isRefreshing,
      );
}
