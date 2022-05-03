import 'package:flutter/material.dart';

import 'language_enum.dart';

class LanguageManager {
  static LanguageManager? _instance;
  static LanguageManager get instance {
    _instance ??= LanguageManager._init();
    return _instance!;
  }

  LanguageManager._init();

  final en = Languages.en.locale;
  final tr = Languages.tr.locale;

  List<Locale> get supportedLocales => [tr, en];
}
