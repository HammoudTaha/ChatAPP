part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

class CheckPhoneFoundOnChatEvent extends HomeEvent {
  final String phone;
  const CheckPhoneFoundOnChatEvent(this.phone);
}

class SaveContactEvent extends HomeEvent {
  final ChatEntity chat;
  const SaveContactEvent(this.chat);
}
