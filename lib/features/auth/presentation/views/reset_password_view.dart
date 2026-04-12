import 'package:chatapp/core/constants/colors.dart';
import 'package:chatapp/features/auth/domain/use%20cases/usecases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/config_loading.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/validator_extension.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/fade_in_down_animation.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widgets/auth_text_form_field.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key, required this.phone});
  final String phone;
  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formStateKey = GlobalKey<FormState>();
  String? _code;
  String? _newPassword;
  String? _confirmPassword;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state.status == BlocStatus.loading) {
          EasyLoading.show(status: 'Updating Password...');
        }
        if (state.status == BlocStatus.failure) {
          showToast(state.message);
        }
        if (state.status == BlocStatus.success) {
          context.go('/login');
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              IconButton(
                onPressed: () => context.go(AppRouters.login),
                icon: Icon(Icons.arrow_back_ios),
              ),
              FadeInDownAnimation(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formStateKey,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          Text(
                            "Reset Password",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Please enter a new, unique password to\n secure your account and personal data.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 40),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Code",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          AuthTextFormField(
                            hint: 'Enter Code',
                            preIcon: Icons.security,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            inputAction: TextInputAction.next,
                            onSave: (value) {
                              _code = value;
                            },
                            onSubmit: () {
                              FocusScope.of(context).nextFocus();
                            },
                            onChange: (value) {
                              if (value.isCodeValid) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            validator: (value) {
                              if (value?.replaceAll(' ', '').isEmpty ?? true) {
                                return "Code can't be empty";
                              } else if (!value!.isCodeValid) {
                                return 'Code must be 6 digits';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "New Password",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          AuthTextFormField(
                            hint: 'Enter New Password',
                            preIcon: Icons.lock_outline,
                            inputAction: TextInputAction.next,
                            visibility: true,
                            onSave: (value) {
                              _newPassword = value;
                            },
                            onSubmit: () {
                              FocusScope.of(context).nextFocus();
                            },
                            validator: (value) {
                              if (value?.replaceAll(' ', '').isEmpty ?? true) {
                                return "password can't be empty";
                              } else if (!value!.isPasswordValid) {
                                return 'password must be at least 5 characters';
                              } else {
                                _formStateKey.currentState?.save();
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Confirm Password",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          AuthTextFormField(
                            hint: 'Enter Confirm Password',
                            preIcon: Icons.lock_outline,
                            visibility: true,
                            onSave: (value) {
                              _confirmPassword = value;
                            },
                            validator: (value) {
                              if (value?.replaceAll(' ', '').isEmpty ?? true) {
                                return "password can't be empty";
                              } else if (value != _newPassword) {
                                return 'Password not matched';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            text: 'Update Password',
                            onTap: () {
                              if (_formStateKey.currentState?.validate() ??
                                  false) {
                                _formStateKey.currentState!.save();
                                context.read<AuthBloc>().add(
                                  ResetPasswordEvent(
                                    ResetPasswordParams(
                                      code: _code!,
                                      phone: widget.phone,
                                      newPassword: _newPassword!,
                                      confirmPassword: _confirmPassword!,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
