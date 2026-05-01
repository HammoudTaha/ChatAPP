import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:chatapp/features/home/domain/usecases/save_contact_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/enums.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/usecases/check_phone_found_on_chat_usecase.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SaveContactUseCase _saveContactUseCase;
  final CheckPhoneFoundOnChatUseCase _checkPhoneFoundOnChatUseCase;

  HomeBloc(this._checkPhoneFoundOnChatUseCase, this._saveContactUseCase)
    : super(const HomeState()) {
    on<CheckPhoneFoundOnChatEvent>(
      _onCheckPhoneFoundOnChat,
      transformer: restartable(),
    );
    on<SaveContactEvent>(_onSaveChat, transformer: restartable());
  }

  Future<void> _onCheckPhoneFoundOnChat(
    CheckPhoneFoundOnChatEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(CheckPhoneFoundOnChatState(checkStatus: BlocStatus.loading));
    final result = await _checkPhoneFoundOnChatUseCase.call(event.phone);
    result.fold(
      (failure) {
        emit(
          CheckPhoneFoundOnChatState(
            checkStatus: BlocStatus.failure,
            message: failure.message,
          ),
        );
      },
      (message) {
        emit(
          CheckPhoneFoundOnChatState(
            checkStatus: BlocStatus.success,
            message: message,
          ),
        );
      },
    );
  }

  Future<void> _onSaveChat(
    SaveContactEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const SaveContactState());
    final result = await _saveContactUseCase.call(event.chat);
    result.fold(
      (failure) {
        emit(
          SaveContactState(
            checkStatus: BlocStatus.failure,
            message: failure.message,
          ),
        );
      },
      (_) {
        emit(const SaveContactState(checkStatus: BlocStatus.success));
      },
    );
  }
}
