import 'package:equatable/equatable.dart';
import 'package:quraan/model/reciters_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoriteState {}

class FavoritesLoading extends FavoriteState {}

class FavoritesLoaded extends FavoriteState {
  final List<int> favoriteIds;
  final List<Reciter> reciters;

  const FavoritesLoaded({required this.favoriteIds, required this.reciters});

  @override
  List<Object?> get props => [favoriteIds, reciters];
}

class FavoritesError extends FavoriteState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
