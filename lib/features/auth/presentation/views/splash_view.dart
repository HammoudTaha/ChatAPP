import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/widgets/custom_chat_icon.dart';
import '../bloc/auth/auth_bloc.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (context.mounted) {
        context.read<AuthBloc>().add(const CheckAuthStatusEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == BlocStatus.success) {
          if ((state as CheckAuthStateState).isLoggedIn) {
            context.go('/home');
          } else {
            context.go('/login');
          }
        } else if (state.status == BlocStatus.failure) {
          context.go('/login');
        }
      },
      listenWhen: (_, current) => current is CheckAuthStateState,
      child: Scaffold(body: Center(child: CustomChatIcon())),
    );
  }
}
