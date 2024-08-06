// quran_event.dart

part of 'quran_bloc.dart';

abstract class AudioQuranEvent extends Equatable {
  const AudioQuranEvent();

  @override
  List<Object> get props => [];
}

class LoadAudioQuranEvent extends AudioQuranEvent {
  final String languageCode;

  const LoadAudioQuranEvent({required this.languageCode});

  @override
  List<Object> get props => [languageCode];
}
