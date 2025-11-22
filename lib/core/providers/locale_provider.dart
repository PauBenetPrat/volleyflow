import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    // Inicialment null per usar l'idioma del sistema
    return null;
  }

  void setLocale(Locale locale) {
    state = locale;
  }

  void clearLocale() {
    state = null; // Torna a usar l'idioma del sistema
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(() {
  return LocaleNotifier();
});

