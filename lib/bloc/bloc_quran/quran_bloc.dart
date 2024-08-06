import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quraan/model/quran_model.dart';
import 'package:quraan/repository/quran_repository_arb.dart';

part 'quran_event.dart';
part 'quran_state.dart';

// quran_bloc.dart

class AudioQuranBloc extends Bloc<AudioQuranEvent, AudioQuranState> {
  final AudioQuranRepository audioQuranRepository;

  AudioQuranBloc(this.audioQuranRepository) : super(LoadingAudioQuran()) {
    on<LoadAudioQuranEvent>((event, emit) async {
      emit(LoadingAudioQuran());
      try {
        print('Loading Quran data for language: ${event.languageCode}');
        final List<Datum> audioList =
            await audioQuranRepository.getAudioQuran(event.languageCode);
        emit(LoadedAudioQuran(audioList: audioList));
      } catch (e) {
        if (e is SocketException) {
          emit(ErrorInLoadAudioQuran(errorMsg: 'Check your internet network'));
        } else {
          emit(ErrorInLoadAudioQuran(errorMsg: 'Something Went Wrong'));
        }
      }
    });
  }
}
