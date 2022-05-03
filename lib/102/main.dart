import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'apis/login_api.dart';
import 'apis/notes_api.dart';
import 'bloc/actions.dart';
import 'bloc/app_bloc.dart';
import 'bloc/app_state.dart';
import 'dialogs/generic_dialog.dart';
import 'dialogs/loading_screan.dart';
import 'models.dart';
import 'views/iterable_list_view.dart';
import 'views/login_view.dart';
import '../public/language/language_manager.dart';
import '../public/language/locale_keys.g.dart';

// ignore: constant_identifier_names
const lang_asset_path = 'asset/lang';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Material App',
      home: BlocProvider(
        create: (context) => AppBloc(
          loginApi: LoginApi(),
          notesApi: NotesApi(),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.e102_homePage.tr()),
          ),
          body: BlocConsumer<AppBloc, AppState>(
            listener: (context, appState) {
              //* loading screen
              if (appState.isLoading) {
                LoadingScreen.instance().show(
                  context: context,
                  text: LocaleKeys.e102_pleaseWait.tr(),
                );
              } else {
                LoadingScreen.instance().hide();
              }
              //* display possible errors
              final loginError = appState.loginError;
              if (loginError != null) {
                showGenericDialog<bool>(
                  context: context,
                  title: LocaleKeys.e102_loginErrorDialogTitle.tr(),
                  content: LocaleKeys.e102_loginErrorDialogContent.tr(),
                  optionBuilder: () => {LocaleKeys.e102_ok.tr(): true},
                );
              }
              //* if we are logged in, but we have no fetched notes, fetch them now
              if (appState.isLoading == false &&
                  appState.loginError == null &&
                  appState.loginHandle == const LoginHandle.fooBar() &&
                  appState.fetchedNotes == null) {
                context.read<AppBloc>().add(
                      const LoadNotesAction(),
                    );
              }
            },
            builder: (context, appState) {
              final notes = appState.fetchedNotes;
              if (notes == null) {
                return LoginView(
                  onLoginTapped: (email, password) {
                    context.read<AppBloc>().add(
                          LoginAction(
                            email: email,
                            password: password,
                          ),
                        );
                  },
                );
              } else {
                return notes.toListView();
              }
            },
          ),
        ),
      ),
    );
  }
}
