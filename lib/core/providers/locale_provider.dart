import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    // Inicialment null per usar l'idioma del sistema
  }

  void setLocale(Locale locale) {
    state = locale;
  }

  void clearLocale() {
    state = null; // Torna a usar l'idioma del sistema
  }
}

