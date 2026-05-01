part of 'home_bloc.dart';

class HomeState extends Equatable {
  final BlocStatus checkStatus;
  final String? message;
  const HomeState({this.checkStatus = BlocStatus.initial, this.message});

  @override
  List<Object?> get props => [checkStatus, message];
}

class CheckPhoneFoundOnChatState extends HomeState {
  const CheckPhoneFoundOnChatState({
    super.checkStatus = BlocStatus.loading,
    super.message,
  });

  @override
  List<Object?> get props => [checkStatus, message];
}

class SaveContactState extends HomeState {
  const SaveContactState({
    super.checkStatus = BlocStatus.loading,
    super.message,
  });

  @override
  List<Object?> get props => [checkStatus, message];
}
