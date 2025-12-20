part of 'list_children_bloc.dart';

abstract class ListChildrenState extends Equatable {}

class UpdateInfoChildrenInitial extends ListChildrenState {
  @override
  List<Object?> get props => [];
}

class UpdateInfoChildrenFailure extends ListChildrenState {
  final String mess;

  UpdateInfoChildrenFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}

class UpdateInfoChildrenSuccess extends ListChildrenState {
  final String mess;

  UpdateInfoChildrenSuccess({required this.mess});

  @override
  List<Object?> get props => [mess];
}
