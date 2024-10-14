import 'package:chat_app/widgets/contact_card_gesture_detector.dart';
import 'package:flutter/cupertino.dart';

class PrivateChat extends StatefulWidget {
  const PrivateChat({super.key, required this.contactName});

  final String contactName;

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: "返回",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: Text(widget.contactName),
        trailing: ContactCardGestureDetector(contactName: widget.contactName,),
      ),
      //TODO:消息列表
      child: Center(),
    );
  }
}
