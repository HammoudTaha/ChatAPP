import 'package:chatapp/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/config_loading.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/validator_extension.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_chat_icon.dart';
import '../../../../core/widgets/fade_in_down_animation.dart';
import '../../domain/use cases/login_usecase.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widgets/auth_text_form_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formStateKey = GlobalKey<FormState>();
  String? _phone;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        EasyLoading.dismiss();
        if (state.status == BlocStatus.loading) {
          EasyLoading.show(status: 'loading...');
        }
        if (state.status == BlocStatus.failure) {
          showToast(state.message);
        }
        if (state.status == BlocStatus.success) {
          context.go('/home');
        }
      },
      listenWhen: (_, current) => current is LoginState,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FadeInDownAnimation(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Form(
                key: _formStateKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    const CustomChatIcon(),
                    Text(
                      "Welcome Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Please enter your details to sign in to \n your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                    const SizedBox(height: 40),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Phone Number",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    AuthTextFormField(
                      hint: 'Enter Phone number',
                      preIcon: Icons.phone,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      inputAction: TextInputAction.next,
                      onSave: (value) {
                        _phone = value;
                      },
                      onSubmit: () {
                        FocusScope.of(context).nextFocus();
                      },
                      onChange: (value) {
                        if (value.isPhoneValid) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      validator: (value) {
                        if (value?.replaceAll(' ', '').isEmpty ?? true) {
                          return "phone can't be empty";
                        } else if (!value!.isPhoneValid) {
                          return 'invalid phone number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    AuthTextFormField(
                      hint: 'Enter Password',
                      preIcon: Icons.lock,
                      visibility: true,
                      onSave: (value) {
                        _password = value;
                      },
                      validator: (value) {
                        if (value?.replaceAll(' ', '').isEmpty ?? true) {
                          return "password can't be empty";
                        } else if (!value!.isPasswordValid) {
                          return 'password must be at 5 character';
                        } else {
                          return null;
                        }
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          context.push('/forget-password');
                        },
                        child: Text(
                          'Forget Password?',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Sign In',
                      onTap: () {
                        if (_formStateKey.currentState?.validate() ?? false) {
                          _formStateKey.currentState!.save();
                          context.read<AuthBloc>().add(
                            LoginEvent(
                              LoginParams(phone: _phone!, password: _password!),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 3,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push(AppRouters.register);
                          },
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Powered By Hammoud Taha",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
