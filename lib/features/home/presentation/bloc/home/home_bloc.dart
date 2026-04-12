import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/enums.dart';
import '../../../domain/usecases/check_phone_found_on_chat_usecase.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CheckPhoneFoundOnChatUseCase _checkPhoneFoundOnChatUseCase;

  HomeBloc(this._checkPhoneFoundOnChatUseCase) : super(const HomeState()) {
    on<CheckPhoneFoundOnChatEvent>(
      _onCheckPhoneFoundOnChat,
      transformer: restartable(),
    );
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

  // Future<void> _onSaveContact(
  //   SaveContactEvent event,
  //   Emitter<HomeState> emit,
  // ) async {
  //   emit(
  //     state.copyWith(
  //       saveStatus: BlocStatus.loading,
  //       saveMessage: null,
  //       isContactSaved: false,
  //     ),
  //   );

  // final result = await _saveContactUseCase.call(
  //   //SaveContactParams(name: event.name, phone: event.phone),
  // );

  // result.fold(
  //   (failure) {
  //     emit(
  //       state.copyWith(
  //         saveStatus: BlocStatus.failure,
  //         saveMessage: failure.message,
  //         isContactSaved: false,
  //       ),
  //     );
  //   },
  //   (_) {
  //     emit(
  //       state.copyWith(
  //         saveStatus: BlocStatus.success,
  //         saveMessage: null,
  //         isContactSaved: true,
  //       ),
  //     );
  //   },
  //);
  //}
}
