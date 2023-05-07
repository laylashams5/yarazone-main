import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:linkwell/linkwell.dart';
import 'package:mime/mime.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:path_provider/path_provider.dart' as p;

class MessageRecevierScreen extends StatefulWidget {
  final String? message;
  List? attachments;
  String? createdAt;
  MessageRecevierScreen(
      {Key? key, this.message, this.attachments, this.createdAt})
      : super(key: key);
  @override
  State<MessageRecevierScreen> createState() => _MessageRecevierScreenState();
}

class _MessageRecevierScreenState extends State<MessageRecevierScreen> {
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
      print(file.path);
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
        margin: const EdgeInsets.only(right: 10, top: 20, bottom: 10, left: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: widget.message != null &&
                              widget.message != '' &&
                              widget.message !=
                                  'welcome to yarazon choose department[{"1":"General"},{"2":"New Order"},{"3":"Complain"}]'
                          ? Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: LinkWell(
                                '${widget.message!}',
                                linkStyle: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 15,
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                              ),
                            )
                          : null,
                    ),
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
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 20,
                                          color: primaryColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        transformationController:
                                            _zoomController,
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
                                  )),
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
                                          color: primaryColor,
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
                child: widget.message != null &&
                        widget.message != '' &&
                        widget.message !=
                            'welcome to yarazon choose department[{"1":"General"},{"2":"New Order"},{"3":"Complain"}]'
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
