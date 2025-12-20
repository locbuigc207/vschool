part of 'heath_bloc.dart';

abstract class HeathEvent extends Equatable {
  const HeathEvent();
}

class HeathInitial extends HeathEvent {
  @override
  List<Object?> get props => [];
}

class GetHeathInfo extends HeathEvent {
  final int studentId;

  const GetHeathInfo({required this.studentId});

  @override
  List<Object?> get props => [];
}
