import 'package:chatapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chatapp/features/chat/domain/entities/message.dart';
import 'package:chatapp/features/chat/presentation/widgets/custom_message_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/di.dart';
import '../../data/repositories/message_repository_impl.dart';
import '../widgets/custom_bottom_bar.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key, required this.chatId});
  final String chatId;
  Stream<List<Message>> messages() async* {
    yield* (getIt<ChatRepositoryImpl>()).watchMessages(chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F7FB),
      appBar: AppBar(backgroundColor: Colors.white, scrolledUnderElevation: 0),
      body: Column(
        children: [
          StreamBuilder(
            stream: messages(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => CustomMessageItem(
                        message: snapshot.data![index],
                        isMe:
                            snapshot.data![index].senderId ==
                            context.read<AuthBloc>().state.user!.id,
                      ),
                    ),
                  ),
                );
              } else {
                return const Spacer();
              }
            },
          ),
          CustomBottomBar(chatId: chatId),
        ],
      ),
    );
  }
}
