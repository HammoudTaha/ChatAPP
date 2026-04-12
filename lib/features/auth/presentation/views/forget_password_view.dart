import 'package:animate_do/animate_do.dart';
import 'package:chatapp/core/widgets/custom_button.dart';
import 'package:chatapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/config_loading.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/validator_extension.dart';
import '../widgets/auth_text_form_field.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final _formStateKey = GlobalKey<FormState>();
  String? _phone;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state.status == BlocStatus.loading) {
          EasyLoading.show(status: 'checking phone...');
        }
        if (state.status == BlocStatus.failure) {
          showToast(state.message);
        }
        if (state.status == BlocStatus.success) {
          context.push(
            '/verification',
            extra: {
              'params': {'phone': _phone},
              'verificationFrom': VerificationFrom.forgetPassword,
            },
          );
        }
      },
      listenWhen: (_, current) => current is CheckPhoneExistenceState,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_ios),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: FadeInDown(
                  duration: Duration(seconds: 2),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formStateKey,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      child: Column(
                        children: [
                          const SizedBox(height: 200),
                          Text(
                            "Reset Password",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Enter the phone associated with \n your account and we'll send you\n a OTP code to reset your password.",
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
                              "Phone Number",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          AuthTextFormField(
                            hint: 'Enter Phone number',
                            preIcon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            onSave: (value) {
                              _phone = value;
                            },
                            onSubmit: () {
                              FocusScope.of(context).unfocus();
                            },
                            onChange: (value) {
                              if (value.isPhoneValid) {
                                FocusScope.of(context).unfocus();
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
                          const SizedBox(height: 50),
                          CustomButton(
                            text: 'Check Phone',
                            onTap: () {
                              if (_formStateKey.currentState?.validate() ??
                                  false) {
                                _formStateKey.currentState!.save();
                                context.read<AuthBloc>().add(
                                  CheckPhoneExistenceEvent(_phone!),
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
