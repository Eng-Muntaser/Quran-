import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quraan/bloc/bloc_local_Reciters/local_reciters_event.dart';
import 'package:quraan/bloc/bloc_local_Reciters/local_reciters_state.dart';
import 'package:quraan/model/reciters_model.dart';
import 'package:quraan/repository/local_reciters_repository.dart';

class LocalRecitersBloc extends Bloc<LocalRecitersEvent, LocalRecitersState> {
  final LocalRecitersRepository localRecitersRepository;

  LocalRecitersBloc(this.localRecitersRepository)
      : super(LoadingLocalReciters()) {
    on<LoadLocalRecitersEvent>((event, emit) async {
      emit(LoadingLocalReciters());
      try {
        final List<Reciter> localreciters =
            await localRecitersRepository.getLocalReciters(event.language);
        emit(LoadedLocalReciters(localreciters: localreciters));
      } catch (e) {
        if (e is SocketException) {
          emit(ErrorInLoadLocalReciters(
              errorMsg: 'Check your internet network'));
        } else {
          emit(ErrorInLoadLocalReciters(errorMsg: 'Something Went Wrong'));
        }
      }
    });
  }
}
