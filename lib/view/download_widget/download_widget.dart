import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as Path;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:quraan/view/download_widget/directory.dart';
import 'package:quraan/view/reciters_screen.dart';

class DownloadWidget extends StatefulWidget {
  final String suraNoDownloading;
  DownloadWidget({
    super.key,
    required this.suraNoDownloading,
  });

  @override
  State<DownloadWidget> createState() =>
      _DownloadWidgetState(suraNoDownloading);
}

class _DownloadWidgetState extends State<DownloadWidget> {
  final String suraNoDownloading;
  // String SuraNumber = "002.mp3";
  // String baseUrl = "https://server8.mp3quran.net/download/ahmad_huth/002.mp3";
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  _DownloadWidgetState(this.suraNoDownloading);

  startDownload() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      dowloading = true;
      progress = 0;
    });

    try {
      await Dio().download(
          RecitersScreen.server.toString() + suraNoDownloading, filePath,
          onReceiveProgress: (count, total) {
        setState(() {
          progress = (count / total);
        });
      }, cancelToken: cancelToken);
      setState(() {
        dowloading = false;
        fileExists = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        dowloading = false;
      });
    }
  }

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      dowloading = false;
    });
  }

  checkFileExit() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  // openfile() {
  //   OpenFile.open(filePath);
  //   print("fff $filePath");
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileName =
          '${RecitersScreen.ReiterId}_${RecitersScreen.moshafTypeRewaya}_${suraNoDownloading}';
    });
    // setState(() {
    //   fileName = Path.basename(
    //       "https://server8.mp3quran.net/download/ahmad_huth/002.mp3");
    // });
    checkFileExit();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (fileExists == true && dowloading == false)
            InkWell(
              child: const Icon(
                Icons.check_box,
                color: Colors.transparent,
                size: 25,
              ),
              onTap: () async {
                ////////////////
              },
            )
          else if (dowloading == false && fileExists == false)
            InkWell(
              child: const SizedBox(
                width: 30,
                height: 30,
                child: Icon(
                  Icons.file_download_outlined,
                  color: Colors.blueGrey,
                  size: 30,
                ),
              ),
              onTap: () async {
                startDownload();
                setState(() {
                  dowloading == true;
                  fileName =
                      '${RecitersScreen.ReiterId}_${RecitersScreen.moshafTypeRewaya}_${suraNoDownloading}';
                });
                print(fileExists);
              },
            )
          else if (dowloading == true)
            InkWell(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularPercentIndicator(
                  radius: 15.0,
                  lineWidth: 5.0,
                  percent: (progress),
                  center: progress == 0
                      ? const Text("")
                      : Text(
                          ((progress * 100).toStringAsFixed(0)),
                          style: const TextStyle(fontSize: 9),
                        ),
                  progressColor: Colors.blue,
                ),
              ),
              onTap: () {
                cancelDownload();
                setState(() {
                  dowloading = false;
                });
              },
            )
        ],
      ),
    );
  }
}
