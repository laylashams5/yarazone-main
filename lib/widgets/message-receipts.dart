import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yarazon/helpers/constants.dart';

class MessageReceipts extends StatelessWidget {
  final BaseMessage passedMessage;
  final bool showTime;
  const MessageReceipts(
      {Key? key, required this.passedMessage, this.showTime = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget receiptIcon = sentIcon();
    print('deliveredAt ${passedMessage.deliveredAt}');
    if (passedMessage.deliveredAt != null) receiptIcon = deliveredIcon();
    if (passedMessage.readAt != null) receiptIcon = readIcon();
    print('readAt ${passedMessage.readAt}');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTime)
          Text(
            receiptFormatter.format(passedMessage.sentAt!),
            style: TextStyle(color: const Color(0xff141414).withOpacity(0.46)),
          ),
        receiptIcon
      ],
    );
  }

  Widget readIcon() {
    return SvgPicture.asset(
      "assets/imgs/MessageDelivered.svg",
      color: Colors.blue,
      width: 16,
      height: 16,
    );
  }

  Widget deliveredIcon() {
    return SvgPicture.asset(
      "assets/imgs/MessageDelivered.svg",
      width: 16,
      height: 16,
      color: const Color(0xff141414).withOpacity(0.46),
    );
  }

  Widget sentIcon() {
    return SvgPicture.asset(
      "assets/imgs/MessageSent.svg",
      width: 16,
      height: 16,
      color: const Color(0xff141414).withOpacity(0.46),
    );
  }
}
