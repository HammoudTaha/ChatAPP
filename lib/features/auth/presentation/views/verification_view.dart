import 'package:chatapp/core/routes/routes.dart';
import 'package:chatapp/core/widgets/custom_button.dart';
import 'package:chatapp/features/auth/domain/use%20cases/usecases.dart';
import 'package:chatapp/features/auth/presentation/widgets/custom_input_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/config_loading.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/widgets/fade_in_down_animation.dart';
import '../bloc/auth/auth_bloc.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({
    super.key,
    required this.data,
    required this.verificationFrom,
  });
  final Map<String, dynamic> data;
  final VerificationFrom verificationFrom;
  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final _formStateKey = GlobalKey<FormState>();
  String? _d1, _d2, _d3, _d4, _d5, _d6;
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(
      SendVerificationCodeEvent(widget.data['phone'] ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            EasyLoading.dismiss();
            if (state.status == BlocStatus.loading) {
              EasyLoading.show(status: 'Sending Verification Code...');
            }
            if (state.status == BlocStatus.success) {
              showToast('Verification code sent successfully');
            }
            if (state.status == BlocStatus.failure) {
              showToast(state.message);
            }
          },
          listenWhen: (_, current) => current is SendVerificationCodeState,
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            EasyLoading.dismiss();
            if (state.status == BlocStatus.loading) {
              EasyLoading.show(status: 'Verifying...');
            }
            if (state.status == BlocStatus.success) {
              if (widget.verificationFrom == VerificationFrom.registration) {
                context.go(AppRouters.createAccount, extra: widget.data);
              } else {
                context.go(
                  AppRouters.resetPassword,
                  extra: widget.data['phone'] ?? '',
                );
              }
            }
            if (state.status == BlocStatus.failure) {
              showToast(state.message);
            }
          },
          listenWhen: (_, current) => current is VerifiedPhoneState,
        ),
      ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formStateKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          Text(
                            "Enter OTP Code",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "We've sent a 6-digit verification code to\n +963 •••• ••56",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            spacing: 10,
                            children: [
                              CustomIntputItem(
                                onSave: (value) {
                                  _d1 = value;
                                },
                              ),
                              CustomIntputItem(
                                onSave: (value) {
                                  _d2 = value;
                                },
                              ),
                              CustomIntputItem(
                                onSave: (value) {
                                  _d3 = value;
                                },
                              ),
                              CustomIntputItem(
                                onSave: (value) {
                                  _d4 = value;
                                },
                              ),
                              CustomIntputItem(
                                onSave: (value) {
                                  _d5 = value;
                                },
                              ),
                              CustomIntputItem(
                                onSave: (value) {
                                  _d6 = value;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 200),
                          CustomButton(
                            text: 'Verify',
                            onTap: () {
                              if (_formStateKey.currentState?.validate() ??
                                  false) {
                                _formStateKey.currentState!.save();
                                final code = '$_d1$_d2$_d3$_d4$_d5$_d6';
                                context.read<AuthBloc>().add(
                                  VerifyPhoneEvent(
                                    VerifyPhoneParams(
                                      phone: widget.data['phone'] ?? '',
                                      code: code,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 40),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffF3F5F6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xffDDE0E4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.access_time_outlined,
                                  size: 20,
                                  color: Color(0xff555E68),
                                ),
                                Text(
                                  'Code expires in',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '1:59',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 3,
                            children: [
                              const Text(
                                "Didn't receive code?",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.read<AuthBloc>().add(
                                    SendVerificationCodeEvent(
                                      widget.data['phone'] ?? '',
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Resend code",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
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
