part of 'list_children_bloc.dart';

abstract class ListChildrenEvent extends Equatable {}

class UpdatingInfoStudent extends ListChildrenEvent {
  final int? studentId;
  final int? bhytNum;
  final String? cmnd;
  final int? status;
  final bool? gender;
  final String? name;
  final String? studentCode;
  final String? dob;
  final String? email;
  final String? address;
  final int? classId;
  final String? parentPhonenum;

  UpdatingInfoStudent({
    this.studentId,
    this.bhytNum,
    this.cmnd,
    this.status,
    this.gender,
    this.name,
    this.studentCode,
    this.dob,
    this.email,
    this.address,
    this.classId,
    this.parentPhonenum,
  });

  @override
  List<Object?> get props => [];
}
