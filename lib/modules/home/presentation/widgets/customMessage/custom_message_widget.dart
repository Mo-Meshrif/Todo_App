import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../domain/entities/chat_message.dart';
import 'custom_bubble_widget.dart';
import 'cutomAudioButton/record_button.dart';

class MessageWidget extends StatelessWidget {
  final String uid;
  final List<ChatMessage> messages;
  final Future<void> Function(String message) sendMessage;

  final Function(String? recordPath) sendRecord;
  final Function(ChatMessage message) updateMessage;
  const MessageWidget({
    Key? key,
    required this.messages,
    required this.sendMessage,
    required this.sendRecord,
    required this.uid,
    required this.updateMessage,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String message = '';
    bool hideChatBox = false;
    TextEditingController textEditingController = TextEditingController();
    return StatefulBuilder(
      builder: (context, innerState) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              onTap: () => Navigator.pop(context),
              leading: SvgPicture.asset(
                IconAssets.appTitle,
                color: ColorManager.primary,
                width: AppSize.s120,
              ),
              trailing: const Icon(Icons.arrow_downward),
            ),
            const Divider(
              height: 0,
            ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                padding: const EdgeInsets.only(bottom: 10, top: 5),
                itemBuilder: (context, index) {
                  bool user = uid == messages[index].idFrom;
                  return MessageBubble(
                    fromUser: user,
                    chatMessage: messages[index],
                    onPayVoice: () {
                      innerState(
                        () => messages[index] = messages[index].copyBaseWith(
                          isMark: false,
                        ),
                      );
                      updateMessage(messages[index]);
                    },
                  );
                },
              ),
            ),
            Card(
              elevation: 20,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Visibility(
                      visible: !hideChatBox,
                      child: Expanded(
                        child: TextFormField(
                          controller: textEditingController,
                          onChanged: (value) => innerState(
                            () => message = value,
                          ),
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: AppStrings.typeMessage.tr(),
                            hintStyle: const TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    message.isNotEmpty
                        ? IconButton(
                            onPressed: () => sendMessage(message).then(
                              (_) => textEditingController.clear(),
                            ),
                            icon: const Icon(
                              Icons.send,
                              color: Colors.blue,
                            ),
                          )
                        : RecordButton(
                            sendRecord: (recordPath) => sendRecord(recordPath),
                            getTapStatus: (tapStatus) => innerState(
                              () => hideChatBox = tapStatus,
                            ),
                          )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
