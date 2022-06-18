import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_full_learn/104-bloc-with-firebase/auth/auth_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/upload_image.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AppEventGoToRegistration>((event, emit) async {
      emit(
        const AppStateIsInRegistirationView(
          isLoading: false,
        ),
      );
    });

    on<AppEventLogin>((event, emit) async {
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );

      // log the user in
      try {
        final email = event.email;
        final password = event.password;
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // get images for user
        final user = userCredential.user!;
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    on<AppEventGoToLogin>(
      (event, emit) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      },
    );

    on<AppEventRegister>(
      (event, emit) async {
        // start loading
        emit(
          const AppStateIsInRegistirationView(
            isLoading: true,
          ),
        );
        final email = event.email;
        final password = event.password;
        try {
          // create the user
          final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: credentials.user!,
              images: const [],
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateIsInRegistirationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AppEventInitialize>((event, emit) async {
      // get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
        return;
      }
      // go grab the user's uploaded images
      final images = await _getImages(user.uid);
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: images,
        ),
      );
    });

    // lou out event
    on<AppEventLogOut>(
      (event, emit) async {
        // start loading
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        // log the user out
        await FirebaseAuth.instance.signOut();
        // log the user out in the UI as well
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      },
    );

    // handle account deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      // log the user out if we do not have a current user
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
        return;
      }
      // stater loading
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );
      // delete the user folder
      try {
        // delete user folder
        final folderContents = await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          await item.delete().catchError((_) {}); // maybe handle the error
        }
        // delete the folder itself
        await FirebaseStorage.instance.ref(user.uid).delete().catchError((_) {});
        // delete the user
        await user.delete();
        // log the user out
        await FirebaseAuth.instance.signOut();
        // log the user out in the UI as well
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: state.images ?? [],
            authError: AuthError.from(e),
          ),
        );
      } on FirebaseException {
        // we migth not be able to delete the folder
        // log the user out
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      }
    });

    // handle uploading images
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;
        // log user out if we do not have an actual user in app state
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }
        // start the loading process
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );

        // upload the file
        final file = File(event.filePathToUpload);
        await uploadImage(
          file: file,
          userId: user.uid,
        );

        // after upload is complete, grab the latest file references
        final images = await _getImages(user.uid);
        // emit the new images and turn off loading
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) => FirebaseStorage.instance.ref(userId).list().then((listResult) => listResult.items);
}
