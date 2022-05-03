import 'package:flutter/widgets.dart' show Locale;

enum Languages { en, tr }

extension LanguageExtension on Languages {
  Locale get locale {
    switch (this) {
      case Languages.en:
        return const Locale('en', 'US');
      case Languages.tr:
        return const Locale('tr', 'TR');
    }
  }
}
