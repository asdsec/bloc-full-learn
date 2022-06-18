import 'package:bloc_full_learn/104-bloc-with-firebase/bloc/app_event.dart';
import 'package:bloc_full_learn/104-bloc-with-firebase/bloc/app_state.dart';
import 'package:bloc_full_learn/104-bloc-with-firebase/dialogs/show_auth_error.dart';
import 'package:bloc_full_learn/104-bloc-with-firebase/loading/loading_screen.dart';
import 'package:bloc_full_learn/104-bloc-with-firebase/views/photo_gallery_view.dart';
import 'package:bloc_full_learn/104-bloc-with-firebase/views/register_view.dart';
import 'package:bloc_full_learn/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../public/language/language_manager.dart';
import 'bloc/app_bloc.dart';
import 'views/login_view.dart';

// ignore: constant_identifier_names
const lang_asset_path = 'asset/lang';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    EasyLocalization(
      child: const MyApp(),
      supportedLocales: LanguageManager.instance.supportedLocales,
      path: lang_asset_path,
      startLocale: LanguageManager.instance.tr,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Photo Library',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final authError = appState.authError;
            if (authError != null) {
              showAuthErrorDialog(
                error: authError,
                context: context,
              );
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistirationView) {
              return const RegisterView();
            } else {
              // this should never happen
              return Container();
            }
          },
        ),
      ),
    );
  }
}
