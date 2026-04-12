import 'package:chatapp/features/auth/domain/use%20cases/usecases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/config_loading.dart';
import '../../../../core/utils/enums.dart';
import '../bloc/auth/auth_bloc.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  @override
  void initState() {
    context.read<AuthBloc>().add(
      RegisterEvent(
        RegisterParams(
          name: widget.data['name'] ?? '',
          phone: widget.data['phone'] ?? '',
          password: widget.data['password'] ?? '',
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state.status == BlocStatus.loading) {
          EasyLoading.show(status: 'Creating Account...');
        }
        if (state.status == BlocStatus.failure) {
          showToast(state.message);
        }
        if (state.status == BlocStatus.success) {
          context.go('/home');
        }
      },
      child: Scaffold(backgroundColor: Colors.white),
    );
  }
}
