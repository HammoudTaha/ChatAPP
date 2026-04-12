part of 'home_bloc.dart';

class HomeState extends Equatable {
  final BlocStatus checkStatus;

  const HomeState({this.checkStatus = BlocStatus.initial});

  @override
  List<Object?> get props => [checkStatus];
}

class CheckPhoneFoundOnChatState extends HomeState {
  final String? message;
  const CheckPhoneFoundOnChatState({
    super.checkStatus = BlocStatus.loading,
    this.message,
  });

  @override
  List<Object?> get props => [checkStatus, message];
}
