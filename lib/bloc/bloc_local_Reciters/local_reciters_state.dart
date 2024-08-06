import 'package:equatable/equatable.dart';
import 'package:quraan/model/reciters_model.dart';

abstract class LocalRecitersState extends Equatable {}

class LoadingLocalReciters extends LocalRecitersState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadedLocalReciters extends LocalRecitersState {
  final List<Reciter> localreciters;

  LoadedLocalReciters({required this.localreciters});
  @override
  List<Object?> get props => [];
}

class ErrorInLoadLocalReciters extends LocalRecitersState {
  final String errorMsg;

  ErrorInLoadLocalReciters({required this.errorMsg});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
