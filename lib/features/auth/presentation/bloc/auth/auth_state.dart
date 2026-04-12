part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  final BlocStatus status;
  final String? message;
  final UserEntity? user;
  const AuthState({required this.status, this.message, this.user});
  @override
  List<Object?> get props => [status, message, user];
}

class LoginState extends AuthState {
  const LoginState({
    super.status = BlocStatus.initial,
    super.message,
    super.user,
  });
  @override
  List<Object?> get props => [status, message, user];
}

class RegisterState extends AuthState {
  const RegisterState({
    super.status = BlocStatus.initial,
    super.message,
    super.user,
  });
  @override
  List<Object?> get props => [status, message, user];
}

class VerifiedPhoneState extends AuthState {
  const VerifiedPhoneState({
    super.status = BlocStatus.initial,
    super.message,
    super.user,
  });
  @override
  List<Object?> get props => [status, message, user];
}

class ResetPasswordState extends AuthState {
  const ResetPasswordState({
    super.status = BlocStatus.initial,
    super.message,
    super.user,
  });
  @override
  List<Object?> get props => [status, message, user];
}

class SendVerificationCodeState extends AuthState {
  const SendVerificationCodeState({
    super.status = BlocStatus.initial,
    super.message,
    super.user,
  });
  @override
  List<Object?> get props => [status, message, user];
}

class LoggedoutState extends AuthState {
  const LoggedoutState({
    super.status = BlocStatus.initial,
    super.message,
    super.user,
  });
  @override
  List<Object?> get props => [status, message, user];
}

class CheckPhoneAvailabilityState extends AuthState {
  const CheckPhoneAvailabilityState({
    super.status = BlocStatus.initial,
    super.message,
    super.user,
  });
  @override
  List<Object?> get props => [status, message, user];
}

class CheckPhoneExistenceState extends AuthState {
  const CheckPhoneExistenceState({
    super.status = BlocStatus.initial,
    super.message,
    super.user,
  });
  @override
  List<Object?> get props => [status, message, user];
}

class CheckAuthStateState extends AuthState {
  final bool isLoggedIn;
  const CheckAuthStateState({
    super.status = BlocStatus.initial,
    super.message,
    super.user,
    this.isLoggedIn = false,
  });
  @override
  List<Object?> get props => [status, message, isLoggedIn];
}

// class InitialUserState extends AuthState {
//   const InitialUserState();
//   @override
//   List<Object> get props => [];
// }
// class LoadingUserState extends AuthState {
//   const LoadingUserState();
//   @override
//   List<Object> get props => [];
// }
// class FailedUserState extends AuthState {
//   final String message;
//   const FailedUserState(this.message);
//   @override
//   List<Object> get props => [message];
// }
// class LoggedUserState extends AuthState {
//   final UserModel user;
//   const LoggedUserState(this.user);
//   @override
//   List<Object> get props => [user];
// }
// class VerifiedPhoneUserState extends AuthState {
//   const VerifiedPhoneUserState();
//   @override
//   List<Object> get props => [];
// }
// class ResetedPasswordUserState extends AuthState {
//   const ResetedPasswordUserState();
//   @override
//   List<Object> get props => [];
// }
// class SentVerificationCodeState extends AuthState {
//   const SentVerificationCodeState();
//   @override
//   List<Object> get props => [];
// }
// class LoggedoutUserState extends AuthState {
//   const LoggedoutUserState();
//   @override
//   List<Object> get props => [];
// }
