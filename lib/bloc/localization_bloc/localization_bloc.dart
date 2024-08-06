import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'localization_event.dart';
import 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(const LocalizationState(Locale('ar'))) {
    on<ChangeLocale>((event, emit) {
      emit(LocalizationState(event.locale));
    });
  }
}
