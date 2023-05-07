import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as lang;
import 'package:image_picker/image_picker.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/models/chat.dart';
import 'package:yarazon/screens/message-recevier.dart';
import 'package:yarazon/screens/message-sender.dart';
import 'package:yarazon/services/api.dart';

List<Chat> oldMessages = [];

class ChatScreen extends StatefulWidget {
  int? deptId;
  List<Chat>? messageList = [];
  ChatScreen({this.deptId, this.messageList});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var selectedLanguage = lang.Get.locale?.languageCode.obs;
  bool isLoading = false;
  bool connected = false;
  var userId;
  String userID = '';
  final TextEditingController _messageController = TextEditingController();
  var filePath;
  String? fileName = '';
  var userData;
  String porgress = '';
  String imageName = ' ';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Timer? timer;
  @override
  void initState() {
    getUserInfo();
    setState(() {
      // timer =
      //     Timer.periodic(Duration(seconds: 1), (Timer t) => print(channelconnect()));
      if (Token != null) {
        startChat();
      }
    });
    super.initState();

    channelConnect();
  }

  Future<void> channelConnect() async {}

  @override
  void dispose() {
    // timer?.cancel()
    super.dispose();
  }

  _handleFileSelection() async {
    var result = (await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      'pdf',
      'docx',
      'xlsx',
      'doc',
    ]));
    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
        fileName = result.files.single.name;
      });
    }
  }

  void _handleImageSelection() async {
    var pickedFile = (await _picker.getImage(source: ImageSource.gallery));
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('image: $_imageFile');
    }
  }

  Future startChat() async {
    var headers = getHeaderAuth();
    var value = await ApiServices.getApi('chat/start', headers: headers);
    var valueData = json.decode(value);
    valueData.forEach((item) {
      setState(() {
        var content = item as List<dynamic>;
        widget.messageList = content
            .map((model) => Chat.fromJson(model as Map<String, dynamic>))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height * 0.70,
          child: SingleChildScrollView(
              reverse: true,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  reverse: false,
                  itemCount: widget.messageList!.length,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      widget.messageList![index].user_id != userID
                          ? MessageRecevierScreen(
                              //admin orange
                              message: widget.messageList![index].message,
                              attachments:
                                  widget.messageList![index].attachments != null
                                      ? widget.messageList![index].attachments
                                      : [],
                              createdAt: widget.messageList![index].created_at,
                            )
                          : MessageSenderScreen(
                              //user gray
                              photo: imagUrl,
                              message: widget.messageList![index].message,
                              attachments:
                                  widget.messageList![index].attachments != null
                                      ? widget.messageList![index].attachments
                                      : [],
                              createdAt: widget.messageList![index].created_at,
                            ),
                    ]);
                  })),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin:
                const EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
            decoration: BoxDecoration(
                color: Color(0xfff4f4f4),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 15,
                ),
                if (_imageFile != null)
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: FileImage(_imageFile!),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _imageFile = null;
                          });
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                if (filePath != null)
                  Stack(
                    children: [
                      Container(
                        child: Icon(
                          Icons.picture_as_pdf_outlined,
                          size: 50,
                          color: Colors.red,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            filePath = null;
                          });
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: TextField(
                  enableSuggestions: true,
                  controller: _messageController,
                  decoration: InputDecoration(
                      hintText: 'Type message'.tr,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xff333333),
                          overflow: TextOverflow.ellipsis,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                      hintMaxLines: 10),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                )),
                InkWell(
                    onTap: () {
                      _handleFileSelection();
                    },
                    child: Icon(
                      Icons.attach_file,
                      color: primaryColor,
                      size: 20,
                    )),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      _handleImageSelection();
                    },
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: primaryColor,
                      size: 20,
                    )),
                SizedBox(
                  width: 13,
                ),
                InkWell(
                    onTap: () {
                      createChat();
                    },
                    child: Icon(
                      Icons.send,
                      color: primaryColor,
                      size: 20,
                    )),
                SizedBox(
                  width: 13,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  createChat() async {
    // if (connected == true) {
    isLoading = true;
    Dio dio = new Dio();
    FormData formData;
    if (_imageFile != null) {
      imageName = _imageFile!.path.split('/').last;
    }
    if (_messageController.text == '' &&
        _imageFile == null &&
        filePath == null) {
      showErrorMessage('The given data was invalid'.tr);
    } else if (_messageController.text != '' ||
        _imageFile != null ||
        filePath != null) {
      formData = FormData.fromMap({
        "message": await _messageController.text,
        "attachments[]": [
          if (_imageFile != null)
            await MultipartFile.fromFile(_imageFile!.path, filename: imageName),
          if (filePath != null)
            await MultipartFile.fromFile(filePath, filename: fileName),
        ]
      });
      try {
        dio.options.headers['Content-Type'] = 'application/json';
        dio.options.headers['Accept'] = 'application/json';
        dio.options.headers['Access-Control-Allow-Origin'] = '*';
        dio.options.headers['App-Language'] = '${selectedLanguage.obs}';
        dio.options.headers["Authorization"] =
            "Bearer ${storage.read(userToken)}";
        dio.options.headers["Token"] = "Bearer ${storage.read(userToken)}";
        var res = await dio.post("${baseUrl}chat/send-message",
            data: formData,
            onReceiveProgress: (count, total) => {
                  setState(() {
                    porgress =
                        ((count / total) * 100).toStringAsFixed(0) + " %";
                    // showMessage('${porgress}');
                    print(porgress);
                  })
                });
        setState(() {
          isLoading = false;
          _messageController.text = '';
          _imageFile = null;
          filePath = null;
          // startChat();
        });
        // print('res $res');
        // showMessage('Sended Successfully'.tr);
      } catch (e) {
        print('Error $e');
      }
    }
    // } else {
    //   print("Websocket is not connected.");
    //   channelconnect();
    // }
  }

  Future getUserInfo() async {
    isLoading = true;
    var headers = getHeaderAuth();
    var value = await ApiServices.getApi('me', headers: headers);
    if (Token != null) {
      setState(() {
        isLoading = false;
      });
      value = json.decode(value);
      value = value['data'];
      userData = value;
      storage.write('userId', userData['id']);
      userId = storage.read('userId');
      userID = (userId.toString());
    }
  }
}
