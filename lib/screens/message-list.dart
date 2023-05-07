import 'package:flutter/material.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:file_picker/file_picker.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/helpers/loading-indicator.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/services/api.dart';
import 'package:yarazon/widgets/media-message.dart';
import 'package:yarazon/widgets/message.dart';
import 'package:yarazon/helpers/item-fetcher.dart';
import 'package:yarazon/helpers/constants.dart';
import 'dart:math' as math;

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  final Conversation conversation;

  @override
  _MessageListScreenState createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen>
    with MessageListener, GroupListener, UserListener {
  final List<BaseMessage> _messageList = <BaseMessage>[];
  final _itemFetcher = ItemFetcher<BaseMessage>();
  final textKey = const ValueKey<int>(1);

  String listenerId = "message_list_listener";

  var selectedLanguage = Get.locale?.languageCode.obs;
  bool _isLoading = true;
  bool _hasMore = true;
  MessagesRequest? messageRequest;
  String appTitle = "";
  String appSubtitle = "";
  Widget appBarAvatar = Container();
  final formKey = GlobalKey<FormState>();
  String messageText = "";
  bool typing = false;
  final FocusNode _focus = FocusNode();
  String conversationWithId = "";

  @override
  void initState() {
    int _limit = 30;
    String? _avatar;
    CometChat.addUserListener("user_Listener_id", this);
    CometChat.addMessageListener("listenerId", this);
    _focus.addListener(_onFocusChange);

    if (widget.conversation.conversationType == "user") {
      conversationWithId = (widget.conversation.conversationWith as User).uid;
    } else {
      conversationWithId = (widget.conversation.conversationWith as Group).guid;
    }
    if (widget.conversation.conversationType == CometChatReceiverType.user) {
      messageRequest = (MessagesRequestBuilder()
            ..uid = (widget.conversation.conversationWith as User).uid
            ..limit = _limit
            ..hideDeleted = true
            ..categories = [
              CometChatMessageCategory.action,
              CometChatMessageCategory.message,
              CometChatMessageCategory.custom
            ])
          .build();
      appTitle = (widget.conversation.conversationWith as User).name;
      _avatar = (widget.conversation.conversationWith as User).avatar;
      print((widget.conversation.conversationWith));
      appSubtitle = (widget.conversation.conversationWith as User).status ?? '';
      print('userStatus $appSubtitle');
    } else {
      messageRequest = (MessagesRequestBuilder()
            ..guid = (widget.conversation.conversationWith as Group).guid
            ..limit = _limit
            ..hideDeleted = true
            ..categories = [
              CometChatMessageCategory.action,
              CometChatMessageCategory.message,
              CometChatMessageCategory.custom
            ])
          .build();
      appTitle = (widget.conversation.conversationWith as Group).name;
      _avatar = (widget.conversation.conversationWith as Group).icon;
      appSubtitle =
          "${(widget.conversation.conversationWith as Group).membersCount.toString()} members";
    }

    appBarAvatar = Hero(
      tag: widget.conversation,
      child: CircleAvatar(
          maxRadius: 25,
          backgroundColor: primaryColor,
          foregroundColor: Color(0xff333333),
          child: _avatar != null && _avatar.trim() != ''
              ? Image.network(
                  _avatar,
                )
              : Text(appTitle.substring(0, 2))),
    );

    super.initState();
    _isLoading = true;
    _hasMore = true;
    _loadMore();
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    CometChat.removeMessageListener(listenerId);
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      if (widget.conversation.conversationType == CometChatReceiverType.user) {
        User _user = widget.conversation.conversationWith as User;
        CometChat.startTyping(
          receaverUid: _user.uid,
          receiverType: CometChatReceiverType.user,
        );
      } else {
        Group _group = widget.conversation.conversationWith as Group;
        CometChat.startTyping(
          receaverUid: _group.guid,
          receiverType: CometChatReceiverType.group,
        );
      }
    } else if (!_focus.hasFocus) {
      if (widget.conversation.conversationType == CometChatReceiverType.user) {
        User _user = widget.conversation.conversationWith as User;
        CometChat.endTyping(
            receaverUid: _user.uid, receiverType: CometChatReceiverType.user);
      } else {
        Group _group = widget.conversation.conversationWith as Group;
        CometChat.endTyping(
            receaverUid: _group.guid,
            receiverType: CometChatReceiverType.group);
      }
    }
  }

  @override
  void onTextMessageReceived(TextMessage textMessage) async {
    _messageList.insert(0, textMessage);
    setState(() {});
    CometChat.markAsRead(textMessage, onSuccess: (_) {}, onError: (_) {});
  }

  @override
  void onMediaMessageReceived(MediaMessage mediaMessage) {
    if (mounted == true) {
      _messageList.insert(0, mediaMessage);
      setState(() {});
    }
    CometChat.markAsRead(mediaMessage, onSuccess: (_) {}, onError: (_) {});
  }

  @override
  void onCustomMessageReceived(CustomMessage customMessage) {
    _messageList.insert(0, customMessage);
    setState(() {});
  }

  @override
  void onTypingStarted(TypingIndicator typingIndicator) {
    setState(() {
      if (typingIndicator.sender.uid.toLowerCase().trim() ==
          conversationWithId.toLowerCase().trim()) {
        typing = true;
      }
    });
  }

  @override
  void onTypingEnded(TypingIndicator typingIndicator) {
    setState(() {
      if (typingIndicator.sender.uid.toLowerCase().trim() ==
          conversationWithId.toLowerCase().trim()) {
        typing = false;
      }
    });
  }

  @override
  void onMessagesDelivered(MessageReceipt messageReceipt) {
    for (int i = 0; i < _messageList.length; i++) {
      if (_messageList[i].sender!.uid == USERID &&
          _messageList[i].id <= messageReceipt.messageId &&
          _messageList[i].deliveredAt == null) {
        _messageList[i].deliveredAt = messageReceipt.deliveredAt;
      }
    }
    setState(() {});
  }

  @override
  void onMessagesRead(MessageReceipt messageReceipt) {
    for (int i = 0; i < _messageList.length; i++) {
      if (_messageList[i].sender!.uid == USERID &&
          _messageList[i].id <= messageReceipt.messageId &&
          _messageList[i].readAt == null) {
        _messageList[i].readAt = messageReceipt.readAt;
      }
    }
    setState(() {});
  }

  @override
  void onMessageEdited(BaseMessage message) {
    if (mounted == true) {
      for (int count = 0; count < _messageList.length; count++) {
        if (message.id == _messageList[count].id) {
          _messageList[count] = message;
          setState(() {});
          break;
        }
      }
    }
  }

  @override
  void onMessageDeleted(BaseMessage message) {
    int matchingIndex =
        _messageList.indexWhere((element) => (element.id == message.id));
    _messageList.removeAt(matchingIndex);
    setState(() {});
  }

  // Triggers fetch() and then add new items or change _hasMore flag
  void _loadMore() {
    _isLoading = true;
    _itemFetcher
        .fetchPreviuos(messageRequest)
        .then((List<BaseMessage> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _messageList.addAll(fetchedList.reversed);
        });
      }
    });
  }

  deleteMessage(BaseMessage message) async {
    int matchingIndex =
        _messageList.indexWhere((element) => (element.id == message.id));

    await CometChat.deleteMessage(message.id,
        onSuccess: (_) {}, onError: (_) {});

    _messageList.removeAt(matchingIndex);
    setState(() {});
  }

  editMessage(BaseMessage message, String updatedText) async {
    int matchingIndex =
        _messageList.indexWhere((element) => (element.id == message.id));

    TextMessage editedMessage = message as TextMessage;
    editedMessage.text = updatedText;

    await CometChat.editMessage(editedMessage,
        onSuccess: (BaseMessage updatedMessage) {
      _messageList[matchingIndex] = updatedMessage;
    }, onError: (CometChatException e) {});

    setState(() {});
  }

  addMessage() {
    CometChat.addMessageListener("listenerId", MessageListener());
  }

  Widget getTypingIndicator() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Typing...".tr,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget getMessageComposer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff141414).withOpacity(0.06),
          borderRadius: const BorderRadius.all(
              Radius.circular(8.0) //                 <--- border radius here
              ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: TextField(
                  // textInputAction: TextInputAction.done,
                  // onSubmitted: (value) {
                  //   sendTextMessage();
                  // },
                  cursorColor: const Color(0xff141414).withOpacity(0.58),
                  focusNode: _focus,
                  controller: TextEditingController(text: messageText),
                  onChanged: (val) {
                    messageText = val;
                  },
                  decoration: InputDecoration(
                    hintText: "Message".tr,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xff333333),
                        overflow: TextOverflow.ellipsis,
                        fontFamily:
                            selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                )),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    iconSize: 24,
                    padding: const EdgeInsets.all(0),
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      color: primaryColor,
                      Icons.attachment,
                      size: 24,
                    ),
                    onPressed: sendMediaMessage //do something,
                    ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Transform.rotate(
                    angle: selectedLanguage == "en" ? 0 : 180 * math.pi / 180,
                    child: IconButton(
                        iconSize: 24,
                        padding: const EdgeInsets.all(0),
                        constraints: const BoxConstraints(),
                        icon: SvgPicture.asset(
                          color: Colors.white,
                          "assets/imgs/Send.svg",
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          sendTextMessage();
                        } //do something,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getMessageWidget(int index) {
    if (_messageList[index] is MediaMessage) {
      return MediaMessageWidget(
        passedMessage: (_messageList[index] as MediaMessage),
      );
    } else if (_messageList[index] is TextMessage) {
      return MessageWidget(
        passedMessage: (_messageList[index] as TextMessage),
        deleteFunction: deleteMessage,
        conversation: widget.conversation,
        editFunction: editMessage,
      );
    } else {
      return const Text("No match");
    }
  }

  sendMediaMessage() async {
    late String receiverID;
    late String messageType;
    String receiverType = widget.conversation.conversationType;
    String filePath = "";
    if (widget.conversation.conversationType == "user") {
      receiverID = (widget.conversation.conversationWith as User).uid;
    } else {
      receiverID = (widget.conversation.conversationWith as Group).guid;
    }

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      filePath = result.files.single.path!;

      String? fileExtension = lookupMimeType(result.files.single.path!);
      if (fileExtension != null) {
        if (fileExtension.startsWith("audio")) {
          messageType = CometChatMessageType.audio;
        } else if (fileExtension.startsWith("image")) {
          messageType = CometChatMessageType.image;
        } else if (fileExtension.startsWith("video")) {
          messageType = CometChatMessageType.video;
        } else if (fileExtension.startsWith("application")) {
          messageType = CometChatMessageType.file;
        } else {
          messageType = CometChatMessageType.file;
        }
      }

      MediaMessage mediaMessage = MediaMessage(
          receiverType: receiverType,
          type: messageType,
          receiverUid: receiverID,
          file: filePath);

      await CometChat.sendMediaMessage(mediaMessage,
          onSuccess: (MediaMessage message) {
        debugPrint("Media message sent successfully: ${mediaMessage.metadata}");
        _messageList.insert(0, message);
        setState(() {});
      }, onError: (e) {
        debugPrint("Media message sending failed with exception: ${e.message}");
      });
    } else {
      // User canceled the picker
    }
  }

  sendTextMessage() {
    late String receiverID;
    String messagesText = messageText;
    late String receiverType;
    String type = CometChatMessageType.text;

    if (widget.conversation.conversationType == "user") {
      receiverID = (widget.conversation.conversationWith as User).uid;
      receiverType = CometChatConversationType.user;
    } else {
      receiverID = (widget.conversation.conversationWith as Group).guid;
      receiverType = CometChatConversationType.group;
    }
    TextMessage textMessage = TextMessage(
        text: messagesText,
        receiverUid: receiverID,
        receiverType: receiverType,
        type: type);

    CometChat.sendMessage(textMessage, onSuccess: (TextMessage message) async {
      debugPrint("Message sent successfully:  ${message.text}");
      var headers = getHeaderAuth();
      await ApiServices.getApi(
          'bot?msg=${message.text}&uid=${USERID}',
          headers: headers);
      setState(() {
        _messageList.insert(0, message);
        messageText = "";
      });
    }, onError: (CometChatException e) {
      debugPrint("Message sending failed with exception:  ${e.message}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection:
            selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xfffbfbfb),
          appBar: AppBar(
            backgroundColor: Color(0xfff4f4f4),
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 70,
            leading: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff333333),
                  size: 22,
                  textDirection: selectedLanguage == 'en'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                )),
            titleSpacing: 0,
            title: Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  appTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff333333),
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                ),
                Text(
                  appSubtitle,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: primaryColor,
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                ),
                SizedBox(
                  width: 10,
                ),
                appBarAvatar,
              ],
            )),
          ),
          body: SafeArea(
              child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  // to diisplay loading tile if more items
                  itemCount:
                      _hasMore ? _messageList.length + 1 : _messageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Uncomment the following line to see in real time how ListView.builder works
                    // print('ListView.builder is building index $index');
                    if (index >= _messageList.length) {
                      // Don't trigger if one async loading is already under way
                      if (!_isLoading) {
                        _loadMore();
                      }
                      return const LoadingIndicator();
                    }
                    return getMessageWidget(index);
                  },
                ),
              ),
              if (typing == true) getTypingIndicator(),
              getMessageComposer(context)
            ],
          )),
        ));
  }
}
