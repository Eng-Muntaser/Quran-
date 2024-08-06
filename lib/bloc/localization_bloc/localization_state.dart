import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocalizationState extends Equatable {
  final Locale locale;

  const LocalizationState(this.locale);

  @override
  List<Object?> get props => [locale];
}
