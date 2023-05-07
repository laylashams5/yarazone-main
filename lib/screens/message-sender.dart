import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkwell/linkwell.dart';
import 'package:mime/mime.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:intl/intl.dart' as intl;

class MessageSenderScreen extends StatefulWidget {
  final String? message;
  final String photo;
  List? attachments;
  String? createdAt;
  MessageSenderScreen(
      {Key? key,
      this.message,
      required this.photo,
      this.attachments,
      this.createdAt})
      : super(key: key);

  @override
  State<MessageSenderScreen> createState() => _MessageSenderScreenState();
}

class _MessageSenderScreenState extends State<MessageSenderScreen> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  Dio dio = Dio();
  String porgress = '';

  Future<List<Directory>?> _getExternalStoragePath() {
    return p.getExternalStorageDirectories(type: p.StorageDirectory.downloads);
  }

  Future<void> downloadFile(String url) async {
    try {
      final dirList = await _getExternalStoragePath();
      final path = dirList![0].path;
      final file = File('$path/DownloadedFile');
      await dio.download(url, file.path,
          onReceiveProgress: (count, total) => {
                setState(() {
                  porgress = ((count / total) * 100).toStringAsFixed(0) + " %";
                  // showMessage('${porgress}');
                  print(porgress);
                })
              });

      showMessage('Downloaded Successfully'.tr);
    } catch (e) {
      print(e);
    }
  }

  TransformationController? _zoomController;
  TapDownDetails? tapDownDetials;
  @override
  void initState() {
    super.initState();
    _zoomController = TransformationController();
    dio = Dio();
  }

  @override
  void dispose() {
    super.dispose();
    _zoomController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime formatCreatedAt = DateTime.parse('${widget.createdAt}');
    var lastFomatedCreatedAt =
        intl.DateFormat('yyyy-MM-dd – kk:mm a').format(formatCreatedAt);
    return Container(
        margin: const EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                widget.message != null && widget.message != ''
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(widget.photo),
                        radius: 17,
                      )
                    : Container(),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xfff4f4f4),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: widget.message != null && widget.message != ''
                      ? Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: LinkWell(
                            '${widget.message}',
                            linkStyle: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 14,
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                          ),
                        )
                      : null,
                )
              ]),
              SizedBox(
                width: 10,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: widget.attachments!.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    var fileUrl =
                        '${baseUrlWithoutApi}storage/${widget.attachments![index]}';
                    var fileType = lookupMimeType(fileUrl);
                    return (fileType?.contains('image/') != false)
                        ? Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(top: 10),
                            alignment: selectedLanguage == 'en'
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Row(children: [
                              GestureDetector(
                                onTap: () {
                                  downloadFile(fileUrl);
                                },
                                child: Icon(
                                  Icons.download_outlined,
                                  size: 30,
                                  color: primaryColor,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 20,
                                      color: Color(0xfff4f4f4),
                                    ),
                                    borderRadius: BorderRadius.circular(6)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: GestureDetector(
                                    onDoubleTapDown: (detials) =>
                                        tapDownDetials = detials,
                                    onDoubleTap: () async {
                                      final position =
                                          tapDownDetials!.localPosition;
                                      final double scale = 3;
                                      final x = -position.dx * (scale - 1);
                                      final y = -position.dy * (scale - 1);
                                      final zoomed = Matrix4.identity()
                                        ..translate(x, y)
                                        ..scale(scale);
                                      final end =
                                          _zoomController!.value.isIdentity()
                                              ? zoomed
                                              : Matrix4.identity();
                                      _zoomController?.value = end;
                                    },
                                    onTap: () async {},
                                    child: InteractiveViewer(
                                      transformationController: _zoomController,
                                      panEnabled: false,
                                      scaleEnabled: false,
                                      child: Image.network(
                                        fit: BoxFit.cover,
                                        '$fileUrl',
                                        width: 160,
                                        height: 160,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]))
                        : Container(
                            child: GestureDetector(
                                onTap: () async {},
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        downloadFile(fileUrl);
                                      },
                                      child: Icon(
                                        Icons.download_outlined,
                                        size: 30,
                                        color: primaryColor,
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      margin: const EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                          color: Color(0xfff4f4f4),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      padding: EdgeInsets.all(11.0),
                                      child: Icon(
                                        Icons.picture_as_pdf_outlined,
                                        size: 50,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )));
                  }),
              Container(
                padding: EdgeInsets.all(4),
                child: widget.message != null && widget.message != ''
                    ? Text(
                        '${lastFomatedCreatedAt}',
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 12,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                        ),
                      )
                    : null,
              ),
            ]));
  }
}
