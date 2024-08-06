import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class ToggleFavorite extends FavoriteEvent {
  final int reciterId;

  const ToggleFavorite(this.reciterId);

  @override
  List<Object?> get props => [reciterId];
}
