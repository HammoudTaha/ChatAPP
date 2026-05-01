import 'package:chatapp/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/views/create_account_view.dart';
import '../../features/auth/presentation/views/forget_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/auth/presentation/views/reset_password_view.dart';
import '../../features/auth/presentation/views/splash_view.dart';
import '../../features/auth/presentation/views/verification_view.dart';
import '../../features/chat/presentation/view/chat_view.dart';
import '../../features/home/presentation/view/home_view.dart';
import '../utils/enums.dart';
import '../utils/keys.dart';

final routers = GoRouter(
  initialLocation: AppRouters.splash,
  navigatorKey: navigatorStateKey,
  routes: [
    GoRoute(
      path: AppRouters.login,
      builder: (context, state) {
        return const LoginView();
      },
    ),
    GoRoute(
      path: AppRouters.register,
      builder: (context, state) {
        return const RegisterView();
      },
    ),
    GoRoute(
      path: AppRouters.forgetPassword,
      builder: (context, state) {
        return const ForgetPasswordView();
      },
    ),
    GoRoute(
      path: AppRouters.createAccount,
      builder: (context, state) {
        Map<String, dynamic> extra = state.extra as Map<String, dynamic>? ?? {};
        return CreateAccountView(data: extra);
      },
    ),
    GoRoute(
      path: AppRouters.verification,
      builder: (context, state) {
        Map<String, dynamic> extra = state.extra as Map<String, dynamic>? ?? {};
        final data = extra['params'] as Map<String, dynamic>? ?? {};
        final verificationFrom =
            extra['verificationFrom'] as VerificationFrom? ??
            VerificationFrom.registration;
        return VerificationView(data: data, verificationFrom: verificationFrom);
      },
    ),
    GoRoute(
      path: AppRouters.resetPassword,
      builder: (context, state) {
        final String phone = state.extra as String? ?? '';
        return ResetPasswordView(phone: phone);
      },
    ),
    GoRoute(
      path: AppRouters.splash,
      builder: (context, state) {
        return const SplashView();
      },
    ),
    GoRoute(
      path: AppRouters.home,
      builder: (context, state) {
        return const HomeView();
      },
    ),
    GoRoute(
      path: AppRouters.chat,
      builder: (context, state) {
        final chatId = state.extra as String? ?? '';
        return ChatView(chatId: chatId);
      },
    ),
  ],
);
