import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quraan/generated/l10n.dart';
import 'package:quraan/view/download_widget/download_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:quraan/view/download_widget/directory.dart';
import 'package:quraan/view/reciters_screen.dart';
import 'package:quraan/bloc/bloc_quran/quran_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_wave/audio_wave.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class QuranPage extends StatefulWidget {
  static String? suraNameData;
  static String? audioDirectoryData;
  static String currentIndex = "0";
  static String? audioNo;

  QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isRepeatActive = false;
  bool isPlaying = false;
  bool isPlayingControlWidget = false;
  bool showWave = false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  late Timer timer;
  List<double> heightFactors = [0.1, 0.3, 0.7, 0.4, 0.2, 0.1];

  List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    _subscriptions.add(audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    }));

    _subscriptions.add(audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    }));

    _subscriptions.add(audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
        showWave = isPlaying && position > Duration.zero;
      });
    }));

    _subscriptions.add(audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        position = Duration.zero;
        showWave = false;
      });
    }));

    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (showWave) {
        setState(() {
          heightFactors = List.generate(6, (index) => Random().nextDouble());
        });
      }
    });
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    audioPlayer.dispose();
    timer.cancel();
    super.dispose();
  }

  Future<void> _playSura(int index, LoadedAudioQuran state) async {
    try {
      setState(() {
        isPlayingControlWidget = true;
        QuranPage.suraNameData = state.audioList[index].name;
        QuranPage.audioDirectoryData = state.audioList[index].audio;
        QuranPage.currentIndex = index.toString();
        showWave = false;
      });

      var storePath = await DirectoryPath().getPath();
      var fileName =
          '${RecitersScreen.ReiterId}_${RecitersScreen.moshafTypeRewaya}_${state.audioList[index].audio}';
      var filePath = '$storePath/$fileName';
      bool fileExists = await File(filePath).exists();

      await audioPlayer.play(fileExists
          ? DeviceFileSource(filePath)
          : UrlSource(RecitersScreen.server! + QuranPage.audioDirectoryData!));
    } catch (e) {
      // Handle playback errors
      print('Error playing audio: $e');
    }
  }

  Future<void> _playPreviousSura(LoadedAudioQuran state) async {
    int newIndex = int.parse(QuranPage.currentIndex) - 1;
    if (newIndex >= 0) {
      await _playSura(newIndex, state);
    }
  }

  Future<void> _playNextSura(LoadedAudioQuran state) async {
    int newIndex = int.parse(QuranPage.currentIndex) + 1;
    if (newIndex < state.audioList.length) {
      await _playSura(newIndex, state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<AudioQuranBloc, AudioQuranState>(
        builder: (context, state) {
          if (state is LoadingAudioQuran) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedAudioQuran) {
            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const SizedBox(height: 5),
                    ...List.generate(
                      state.audioList.length,
                      (currentIndex) => _buildSuraList(currentIndex, state),
                    ),
                  ],
                ),
                if (isPlayingControlWidget) _buildAudioPlayerWidget(state),
              ],
            );
          } else if (state is ErrorInLoadAudioQuran) {
            print(state.errorMsg);
            return const Center(child: Text("حدث خطأ ما"));
          }
          return const Center(child: Text("حدث خطأ ما"));
        },
      ),
    );
  }

  Align _buildAudioPlayerWidget(LoadedAudioQuran state) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0277BD),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          height: 190,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    splashColor: const Color(0xFF0277BD),
                    child: const Icon(
                      Icons.close,
                      size: 25,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      await audioPlayer
                          .stop(); // Use stop() instead of release()
                      setState(() {
                        isPlayingControlWidget = false;
                        showWave = false;
                      });
                    },
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Center(
                      child: QuranPage.suraNameData == null
                          ? const Text("")
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  QuranPage.suraNameData!,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                if (position == Duration.zero)
                                  const SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  )
                                else
                                  const SizedBox.shrink(),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: 25),
                ],
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Slider(
                  thumbColor: Colors.white,
                  activeColor: Colors.blue[200],
                  inactiveColor: Colors.grey[300],
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final newPosition = Duration(seconds: value.toInt());
                    await audioPlayer.seek(newPosition);
                    if (!isPlaying) await audioPlayer.resume();
                  },
                ),
              ),
              if (isPlaying)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _printDuration(position),
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        _printDuration(duration - position),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(width: 30),
                    SizedBox(
                      width: 155,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            splashColor: const Color(0xFF0277BD),
                            child: const Icon(
                              Icons.skip_next_rounded,
                              size: 45,
                              color: Colors.white,
                            ),
                            onTap: () async {
                              await _playNextSura(state);
                            },
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isPlaying) {
                                await audioPlayer.pause();
                              } else {
                                await audioPlayer.resume();
                              }
                            },
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle_filled_rounded
                                  : Icons.play_circle_filled_rounded,
                              color: Colors.white,
                            ),
                            iconSize: 45,
                          ),
                          InkWell(
                            splashColor: const Color(0xFF0277BD),
                            child: const Icon(
                              Icons.skip_previous_rounded,
                              size: 45,
                              color: Colors.white,
                            ),
                            onTap: () async {
                              await _playPreviousSura(state);
                            },
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Icon(
                        Icons.repeat_rounded,
                        size: 30,
                        color: isRepeatActive ? Colors.black : Colors.white,
                      ),
                      onTap: () async {
                        setState(() {
                          isRepeatActive = !isRepeatActive;
                        });
                        await audioPlayer.setReleaseMode(
                          isRepeatActive ? ReleaseMode.loop : ReleaseMode.stop,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: .7,
      leading: IconButton(
        onPressed: () async {
          await audioPlayer.stop(); // Use stop() instead of release()
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      backgroundColor: const Color(0xFF0277BD),
      toolbarHeight: 160,
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S.of(context).reciterVoice,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    RecitersScreen.recitersName.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    maxLines: 3,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    "${RecitersScreen.rewayatName}",
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Shimmer.fromColors(
              baseColor: Colors.black87,
              highlightColor: const Color(0xFFFFD700),
              child: Image.asset(
                "assets/ayah.png",
                color: Colors.black,
                height: 130,
                width: 130,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildSuraList(int currentIndex, LoadedAudioQuran state) {
    return Column(
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: SizedBox(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          state.audioList[currentIndex].name.toString(),
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 40,
                  child: QuranPage.currentIndex == currentIndex.toString() &&
                          isPlaying &&
                          showWave
                      ? AudioWave(
                          bars: heightFactors
                              .map((heightFactor) => AudioWaveBar(
                                  heightFactor: heightFactor,
                                  color: const Color(0xFF0277BD)))
                              .toList(),
                          height: 20,
                          width: 40,
                        )
                      : InkWell(
                          onTap: () async {
                            await _playSura(currentIndex, state);
                          },
                          child: const Icon(
                            Icons.headphones_rounded,
                            color: Color(0xFF0277BD),
                          ),
                        ),
                ),
                const SizedBox(width: 40),
                DownloadWidget(
                  suraNoDownloading:
                      state.audioList[currentIndex].audio.toString(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
