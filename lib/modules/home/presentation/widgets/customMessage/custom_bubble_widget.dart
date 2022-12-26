import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../../../../../app/helper/enums.dart';
import '../../../domain/entities/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final bool fromUser;
  final ChatMessage chatMessage;
  final Function() onPayVoice;

  const MessageBubble({
    Key? key,
    required this.fromUser,
    required this.chatMessage,
    required this.onPayVoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Column(
        crossAxisAlignment:
            fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          chatMessage.type == MessageType.text
              ? Material(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(50),
                    bottomLeft: fromUser
                        ? const Radius.circular(50)
                        : const Radius.circular(0),
                    bottomRight: fromUser
                        ? const Radius.circular(0)
                        : const Radius.circular(50),
                    topRight: const Radius.circular(50),
                  ),
                  color: fromUser ? Colors.blue : Colors.white,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                      chatMessage.content,
                      style: TextStyle(
                        color: fromUser ? Colors.white : Colors.blue,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              : VoiceMessage(
                  audioSrc: chatMessage.content,
                  played: !chatMessage.isMark ,
                  me: fromUser,
                  meBgColor: Colors.blue,
                  contactBgColor: Colors.white,
                  onPlay: onPayVoice,
                ),
        ],
      ),
    );
  }
}
