import 'package:flutter/material.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/constants.dart';
import 'package:yarazon/widgets/message-receipts.dart';

class MessageWidget extends StatefulWidget {
  final TextMessage passedMessage;
  final Function(BaseMessage msg) deleteFunction;
  final Function(BaseMessage, String) editFunction;
  final Conversation conversation;
  const MessageWidget(
      {Key? key,
      required this.passedMessage,
      required this.deleteFunction,
      required this.conversation,
      required this.editFunction})
      : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  String? text;
  bool sentByMe = false;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    var user = await CometChat.getLoggedInUser();
    setState(() {
      USERID = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (USERID == widget.passedMessage.sender!.uid) {
      sentByMe = true;
    } else {
      sentByMe = false;
    }

    text = widget.passedMessage.text;
    Color background = sentByMe == true
        ? const Color(0xFFfbf3ec).withOpacity(0.92)
        : const Color(0xfff4f4f4).withOpacity(0.92);

    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              sentByMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: null,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text ?? "",
                    style: TextStyle(
                      color: sentByMe == true
                          ? const Color(0xff333333).withOpacity(0.92)
                          : Colors.black,
                          fontSize: 14,
                        fontFamily:
                            selectedLanguage == 'en' ? 'lucymar' : 'LBC'
                    ),
                  ),
                ),
              ),
            ),
            if (sentByMe == true)
              MessageReceipts(passedMessage: widget.passedMessage)
          ],
        ));
  }
}
