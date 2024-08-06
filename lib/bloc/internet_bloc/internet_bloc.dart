import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'internet_event.dart';
import 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _internetConnectionChecker =
      InternetConnectionChecker();

  InternetBloc() : super(InternetDisconnected()) {
    on<CheckInternet>(_checkInternet);
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      add(CheckInternet());
    });
  }

  Future<void> _checkInternet(
      CheckInternet event, Emitter<InternetState> emit) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(InternetDisconnected());
    } else {
      final isConnected = await _internetConnectionChecker.hasConnection;
      if (isConnected) {
        emit(InternetConnected());
      } else {
        emit(InternetNoConnection());
      }
    }
  }
}
