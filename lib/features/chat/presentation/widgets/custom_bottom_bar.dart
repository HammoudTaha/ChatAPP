import 'package:chatapp/core/utils/message_id.dart';
import 'package:chatapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/di.dart';
import '../../data/repositories/message_repository_impl.dart';
import '../../domain/entities/message.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key, required this.chatId});
  final String chatId;
  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F4F7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.grey,
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: _controller,
                      maxLines: 5,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Type here...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Icon(Icons.attach_file, color: Colors.grey),
                ],
              ),
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/send.svg",
              height: 30,
              width: 30,
            ),
            onPressed: () async {
              // (getIt<ChatRepositoryImpl>()).deleteAllChatMessages(
              //   widget.chatId,
              // );
              if (_controller.text
                  .replaceAll(" ", "")
                  .replaceAll("\n", "")
                  .isNotEmpty) {
                (getIt<ChatRepositoryImpl>()).sendLocalMessage(
                  Message(
                    id: generateId(),
                    content: _controller.text,
                    senderId: context.read<AuthBloc>().state.user!.id,
                    createdAt: DateTime.now(),
                    chatId: widget.chatId,
                  ),
                );
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
