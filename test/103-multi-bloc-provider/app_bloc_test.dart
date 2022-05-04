import 'dart:typed_data' show Uint8List;
import 'package:bloc_full_learn/103--multi-bloc-provider/bloc/app_bloc.dart';
import 'package:bloc_full_learn/103--multi-bloc-provider/bloc/app_state.dart';
import 'package:bloc_full_learn/103--multi-bloc-provider/bloc/bloc_events.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final textData1 = 'Foo'.toUint8List();
final textData2 = 'Bar'.toUint8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state of the bloc should be empty',
    build: () => AppBloc(
      urls: [],
    ),
    verify: (appBloc) => expect(appBloc.state, const AppState.empty()),
  );

  // load valid data and compare states
  blocTest<AppBloc, AppState>(
    'Test the ability to load a URL',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLOader: (_) => Future.value(textData1),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: textData1,
        error: null,
      ),
    ],
  );

  // test throwing an error from url loader
  blocTest<AppBloc, AppState>(
    'Throw an error  in url loader and catch it',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLOader: (_) => Future.error(Errors.dummy),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      const AppState(
        isLoading: false,
        data: null,
        error: Errors.dummy,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Test the ability to load more then one URL',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLOader: (_) => Future.value(textData2),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoadNextUrlEvent(),
      );
      appBloc.add(
        const LoadNextUrlEvent(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: textData2,
        error: null,
      ),
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: textData2,
        error: null,
      ),
    ],
  );
}
