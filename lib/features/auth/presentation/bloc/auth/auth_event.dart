part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  final LoginParams loginParams;
  const LoginEvent(this.loginParams);
}

class RegisterEvent extends AuthEvent {
  final RegisterParams registerParams;
  const RegisterEvent(this.registerParams);
}

class SendVerificationCodeEvent extends AuthEvent {
  final String phone;
  const SendVerificationCodeEvent(this.phone);
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class VerifyPhoneEvent extends AuthEvent {
  final VerifyPhoneParams verifyPhoneParams;
  const VerifyPhoneEvent(this.verifyPhoneParams);
}

class ResetPasswordEvent extends AuthEvent {
  final ResetPasswordParams resetPasswordParams;
  const ResetPasswordEvent(this.resetPasswordParams);
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class CheckPhoneAvailabilityEvent extends AuthEvent {
  final String phone;
  const CheckPhoneAvailabilityEvent(this.phone);
}

class CheckPhoneExistenceEvent extends AuthEvent {
  final String phone;
  const CheckPhoneExistenceEvent(this.phone);
}
