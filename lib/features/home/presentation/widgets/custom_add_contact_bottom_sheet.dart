import 'package:chatapp/core/utils/enums.dart';
import 'package:chatapp/core/widgets/custom_button.dart';
import 'package:chatapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chatapp/features/home/data/repositories/home_repository_impl.dart';
import 'package:chatapp/features/home/domain/entities/chat_entity.dart';
import 'package:chatapp/features/home/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/message_id.dart';
import '../../../../core/utils/validator_extension.dart';
import '../bloc/home/home_bloc.dart';

class CustomAddContactBottomSheet extends StatefulWidget {
  const CustomAddContactBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const CustomAddContactBottomSheet(),
    );
  }

  @override
  State<CustomAddContactBottomSheet> createState() =>
      _CustomAddContactBottomSheetState();
}

class _CustomAddContactBottomSheetState
    extends State<CustomAddContactBottomSheet> {
  final _formStateKey = GlobalKey<FormState>();
  String? _phone;
  String? _name;
  String? _errorPhone;
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.checkStatus == BlocStatus.success) {
          _errorPhone = (state as CheckPhoneFoundOnChatState).message;
        }
      },
      listenWhen: (previous, current) => current is CheckPhoneFoundOnChatState,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formStateKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  hint: 'Name',
                  onSave: (value) {
                    _name = value;
                  },
                  validator: (value) {
                    if (value
                            ?.replaceAll(" ", "")
                            .replaceAll("\n", "")
                            .isEmpty ??
                        true) {
                      return 'Name field is required';
                    } else if (value!.length < 5) {
                      return 'Name must be 5 character at least';
                    } else {
                      return null;
                    }
                  },
                  preIcon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hint: 'Mobile number',
                  preIcon: Icons.phone_outlined,
                  onSave: (value) {
                    _phone = value;
                  },
                  helper: _errorPhone,
                  onChange: (value) {
                    _errorPhone = null;
                    if (value.isPhoneValid) {
                      context.read<HomeBloc>().add(
                        CheckPhoneFoundOnChatEvent(value),
                      );
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
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Save Contact',
                  onTap: () {
                    // getIt<HomeRepositoryImpl>().clearChats();
                    if (_formStateKey.currentState?.validate() ?? false) {
                      _formStateKey.currentState!.save();
                      getIt<HomeBloc>().add(
                        SaveContactEvent(
                          ChatEntity(
                            chatId: generateId(),
                            title: _name!,
                            type: ChatType.single,
                            participantIds: [
                              getIt<AuthBloc>().state.user!.phone,
                              _phone!,
                            ],
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                        ),
                      );
                      context.pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
