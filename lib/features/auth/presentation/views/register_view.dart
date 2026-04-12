import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/config_loading.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/validator_extension.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/fade_in_down_animation.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widgets/auth_text_form_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formStateKey = GlobalKey<FormState>();
  String? _phone;
  String? _password;
  String? _name;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state.status == BlocStatus.loading) {
          EasyLoading.show(status: 'loading...');
        }
        if (state.status == BlocStatus.success) {
          context.push(
            AppRouters.verification,
            extra: {
              'verificationFrom': VerificationFrom.registration,
              'params': {'phone': _phone, 'password': _password, 'name': _name},
            },
          );
          _formStateKey.currentState?.reset();
        }
        if (state.status == BlocStatus.failure) {
          showToast(state.message);
        }
      },
      listenWhen: (_, current) {
        return current is CheckPhoneAvailabilityState;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              IconButton(
                onPressed: () => context.pop(),
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
                            "Create Account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Join our community and start chatting with\n friends today.",
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
                              "Your Name",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          AuthTextFormField(
                            hint: 'Enter Your Name',
                            preIcon: Icons.person,
                            autofocus: true,
                            onSave: (value) {
                              _name = value;
                            },
                            onSubmit: () {
                              FocusScope.of(context).nextFocus();
                            },
                            inputAction: TextInputAction.next,
                            validator: (value) {
                              if (value?.replaceAll(' ', '').isEmpty ?? true) {
                                return "name can't be empty";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 10),
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
                            keyboardType: TextInputType.phone,
                            onSave: (value) {
                              _phone = value;
                            },
                            inputAction: TextInputAction.next,
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
                          const SizedBox(height: 10),
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
                            inputAction: TextInputAction.done,
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
                          const SizedBox(height: 30),
                          CustomButton(
                            text: 'Sign Up',
                            onTap: () {
                              if (_formStateKey.currentState?.validate() ??
                                  false) {
                                _formStateKey.currentState!.save();
                                context.read<AuthBloc>().add(
                                  CheckPhoneAvailabilityEvent(_phone!),
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
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: const Text(
                                  "log In",
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
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
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
