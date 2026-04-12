import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/utils/use_case.dart';
import '../../../domain/entities/user.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../../../domain/use cases/usecases.dart';
part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyPhoneUseCase _verifyPhoneUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final CheckPhoneExistenceUseCase _checkPhoneExistenceUseCase;
  final SendVerificationCodeUseCase _sendVerificationCodeUseCase;
  final CheckPhoneAvailabilityUseCase _checkPhoneAvailabilityUseCase;

  AuthBloc(
    this._loginUseCase,
    this._logoutUseCase,
    this._registerUseCase,
    this._verifyPhoneUseCase,
    this._resetPasswordUseCase,
    this._checkAuthStatusUseCase,
    this._checkPhoneExistenceUseCase,
    this._sendVerificationCodeUseCase,
    this._checkPhoneAvailabilityUseCase,
  ) : super(const LoginState()) {
    on<LoginEvent>(_onLoginUser, transformer: droppable());
    on<LogoutEvent>(_onLogoutUser, transformer: droppable());
    on<RegisterEvent>(_onRegisterUser, transformer: droppable());
    on<VerifyPhoneEvent>(_onVerifyPhoneUser, transformer: droppable());
    on<ResetPasswordEvent>(_onResetPasswordUser, transformer: droppable());
    on<CheckAuthStatusEvent>(_onCheckAuthStatusUser, transformer: droppable());
    on<CheckPhoneExistenceEvent>(
      _onCheckPhoneExistenceUser,
      transformer: droppable(),
    );
    on<SendVerificationCodeEvent>(
      _onSendVerificationCodeUser,
      transformer: droppable(),
    );
    on<CheckPhoneAvailabilityEvent>(
      _onCheckPhoneAvailabilityUser,
      transformer: droppable(),
    );
  }

  void _onLoginUser(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const LoginState(status: BlocStatus.loading));
    final result = await _loginUseCase.call(event.loginParams);
    result.fold(
      (failed) {
        emit(LoginState(status: BlocStatus.failure, message: failed.message));
      },
      (user) {
        emit(LoginState(status: BlocStatus.success, user: user));
      },
    );
  }

  void _onRegisterUser(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(const RegisterState(status: BlocStatus.loading));
    final result = await _registerUseCase.call(event.registerParams);

    result.fold(
      (failed) {
        emit(
          RegisterState(status: BlocStatus.failure, message: failed.message),
        );
      },
      (user) {
        emit(RegisterState(status: BlocStatus.success, user: user));
      },
    );
  }

  void _onVerifyPhoneUser(
    VerifyPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const VerifiedPhoneState(status: BlocStatus.loading));
    final result = await _verifyPhoneUseCase.call(event.verifyPhoneParams);
    result.fold(
      (failed) {
        emit(
          VerifiedPhoneState(
            status: BlocStatus.failure,
            message: failed.message,
          ),
        );
      },
      (message) {
        emit(const VerifiedPhoneState(status: BlocStatus.success));
      },
    );
  }

  void _onResetPasswordUser(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const ResetPasswordState(status: BlocStatus.loading));
    final result = await _resetPasswordUseCase.call(event.resetPasswordParams);

    result.fold(
      (failed) {
        emit(
          ResetPasswordState(
            status: BlocStatus.failure,
            message: failed.message,
          ),
        );
      },
      (message) {
        emit(const ResetPasswordState(status: BlocStatus.success));
      },
    );
  }

  void _onLogoutUser(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const LoggedoutState(status: BlocStatus.loading));
    final result = await _logoutUseCase.call(const NoParams());
    result.fold(
      (fail) => emit(
        LoggedoutState(status: BlocStatus.failure, message: fail.message),
      ),
      (user) => emit(const LoggedoutState(status: BlocStatus.success)),
    );
  }

  void _onSendVerificationCodeUser(
    SendVerificationCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const SendVerificationCodeState(status: BlocStatus.loading));
    final result = await _sendVerificationCodeUseCase.call(event.phone);
    result.fold(
      (failed) {
        emit(
          SendVerificationCodeState(
            status: BlocStatus.failure,
            message: failed.message,
          ),
        );
      },
      (message) {
        emit(const SendVerificationCodeState(status: BlocStatus.success));
      },
    );
  }

  void _onCheckAuthStatusUser(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const CheckAuthStateState(status: BlocStatus.loading));
    final result = await _checkAuthStatusUseCase.call(const NoParams());
    result.fold(
      (failed) {
        emit(
          CheckAuthStateState(
            status: BlocStatus.failure,
            message: failed.message,
          ),
        );
      },
      (authStatus) {
        emit(
          CheckAuthStateState(
            status: BlocStatus.success,
            isLoggedIn: authStatus.isAuthenticated,
            user: authStatus.user,
          ),
        );
      },
    );
  }

  void _onCheckPhoneAvailabilityUser(
    CheckPhoneAvailabilityEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const CheckPhoneAvailabilityState(status: BlocStatus.loading));
    final result = await _checkPhoneAvailabilityUseCase.call(event.phone);
    result.fold(
      (failed) {
        emit(
          CheckPhoneAvailabilityState(
            status: BlocStatus.failure,
            message: failed.message,
          ),
        );
      },
      (message) {
        emit(const CheckPhoneAvailabilityState(status: BlocStatus.success));
      },
    );
  }

  void _onCheckPhoneExistenceUser(
    CheckPhoneExistenceEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const CheckPhoneExistenceState(status: BlocStatus.loading));
    final result = await _checkPhoneExistenceUseCase.call(event.phone);
    result.fold(
      (failed) {
        emit(
          CheckPhoneExistenceState(
            status: BlocStatus.failure,
            message: failed.message,
          ),
        );
      },
      (message) {
        emit(const CheckPhoneExistenceState(status: BlocStatus.success));
      },
    );
  }
}
