part of 'quran_bloc.dart';

@immutable
abstract class AudioQuranState extends Equatable {
  const AudioQuranState();

  @override
  List<Object?> get props => [];
}

class LoadingAudioQuran extends AudioQuranState {}

class LoadedAudioQuran extends AudioQuranState {
  final List<Datum> audioList;

  const LoadedAudioQuran({required this.audioList});

  @override
  List<Object?> get props => [audioList];
}

class ErrorInLoadAudioQuran extends AudioQuranState {
  final String errorMsg;

  const ErrorInLoadAudioQuran({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
