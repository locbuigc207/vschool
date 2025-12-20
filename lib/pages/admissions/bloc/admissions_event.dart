part of 'admissions_bloc.dart';

abstract class AdmissionsEvent extends Equatable {
  const AdmissionsEvent();
}

class AdmissionsSubmitting extends AdmissionsEvent {
  final String studentCode;
  final String studentName;
  final String studentDob;
  final String gender;
  final String address;
  final String householderName;
  final String? dadName;
  final String? dadJob;
  final String? dadPhoneNum;
  final String? momName;
  final String? momJob;
  final String? momPhoneNum;
  final String? patronsName;
  final String? patronsJob;
  final String? patronsPhoneNum;
  final String contactAddress;
  final String? note;
  final String? graduateLevel;
  final String? graduateSchool;
  final String? graduateGrades;
  final String desiredSchool;

  const AdmissionsSubmitting({
    required this.studentCode,
    required this.studentName,
    required this.studentDob,
    required this.gender,
    required this.address,
    required this.householderName,
    this.dadName,
    this.dadJob,
    this.dadPhoneNum,
    this.momName,
    this.momJob,
    this.momPhoneNum,
    this.patronsName,
    this.patronsJob,
    this.patronsPhoneNum,
    required this.contactAddress,
    this.note,
    this.graduateLevel,
    this.graduateSchool,
    this.graduateGrades,
    required this.desiredSchool,
  });

  @override
  List<Object?> get props => [];
}
