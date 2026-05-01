import 'package:chatapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chatapp/features/chat/domain/entities/message.dart';
import 'package:chatapp/features/chat/presentation/widgets/custom_message_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/me.dart';
import '../../data/repositories/message_repository_impl.dart';
import '../widgets/custom_bottom_bar.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.chatId});
  final String chatId;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  initState() {
    super.initState();
  }

  Stream<List<Message>> messages() async* {
    yield* (getIt<ChatRepositoryImpl>()).watchMessages(widget.chatId);
  }

  void onNewMessage(List<Message> messages) {
    if (messages.isNotEmpty) {
      (getIt<ChatRepositoryImpl>()).updateStatusToSeen(messages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F7FB),
      appBar: AppBar(backgroundColor: Colors.white, scrolledUnderElevation: 0),
      body: Column(
        spacing: 5,
        children: [
          StreamBuilder(
            stream: messages(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  onNewMessage(
                    snapshot.data!
                        .where(
                          (message) =>
                              (message.status == MessageStatus.sent ||
                                  message.status == MessageStatus.delivered) &&
                              (message.senderId != me.phone),
                        )
                        .toList(),
                  );
                });
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return CustomMessageItem(
                          message: snapshot.data![index],
                          isMe:
                              snapshot.data![index].senderId ==
                              context.read<AuthBloc>().state.user!.phone,
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const Spacer();
              }
            },
          ),
          CustomBottomBar(chatId: widget.chatId),
        ],
      ),
    );
  }
}
