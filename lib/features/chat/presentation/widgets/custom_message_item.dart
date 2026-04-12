import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';
import '../../domain/entities/message.dart';

class CustomMessageItem extends StatelessWidget {
  final Message message;
  final bool isMe;
  const CustomMessageItem({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            margin: EdgeInsets.only(top: 5),
            constraints: BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: isMe ? Color(0xff4987F8) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomRight: isMe ? Radius.circular(3) : Radius.circular(25),
                bottomLeft: isMe ? Radius.circular(25) : Radius.circular(3),
              ),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: message.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  WidgetSpan(child: SizedBox(width: 65)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 8,
            child: Row(
              spacing: 5,
              children: [
                Text(
                  '${message.createdAt.hour < 13 ? message.createdAt.hour.toString().padLeft(2, '0') : (message.createdAt.hour - 12).toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')} ${message.createdAt.hour < 13 ? 'AM' : 'PM'}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
                isMe
                    ? Icon(
                        messageStatus(),
                        color: messageStatusColor(),
                        size: 14,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData messageStatus() {
    switch (message.status) {
      case MessageStatus.sending:
      case MessageStatus.failed:
        return Icons.access_time_outlined;
      case MessageStatus.sent:
        return Icons.done;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.seen:
        return Icons.done_all;
    }
  }

  Color messageStatusColor() {
    switch (message.status) {
      case MessageStatus.sending:
      case MessageStatus.failed:
      case MessageStatus.sent:
      case MessageStatus.delivered:
        return Colors.white60;
      case MessageStatus.seen:
        return Colors.white;
    }
  }
}
