import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingString = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingString close;
  final UpdateLoadingScreen update;
  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}
