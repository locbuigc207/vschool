part of 'invoice_bloc.dart';

abstract class InvoicePageEvent extends Equatable {
  const InvoicePageEvent();
}

class GetAllStudentInvoice extends InvoicePageEvent {
  final int studentId;

  const GetAllStudentInvoice({required this.studentId});

  @override
  List<Object?> get props => [];
}

class GetAllStudentInvoiceByStudentCode extends InvoicePageEvent {
  final String studentCode;

  const GetAllStudentInvoiceByStudentCode({required this.studentCode});

  @override
  List<Object?> get props => [];
}
