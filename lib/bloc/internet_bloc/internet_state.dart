import 'package:equatable/equatable.dart';

abstract class InternetState extends Equatable {
  @override
  List<Object> get props => [];
}

class InternetConnected extends InternetState {}

class InternetDisconnected extends InternetState {}

class InternetNoConnection extends InternetState {}
