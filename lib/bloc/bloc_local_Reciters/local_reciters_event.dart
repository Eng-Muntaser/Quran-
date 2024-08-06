import 'package:equatable/equatable.dart';

abstract class LocalRecitersEvent extends Equatable {
  const LocalRecitersEvent();
}

class LoadLocalRecitersEvent extends LocalRecitersEvent {
  final String language;

  const LoadLocalRecitersEvent(this.language);

  @override
  List<Object?> get props => [language];
}
