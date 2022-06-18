import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

import '../../public/language/locale_keys.g.dart';

Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogDescription;

  const AuthError({
    required this.dialogTitle,
    required this.dialogDescription,
  });

  factory AuthError.from(FirebaseAuthException exception) => authErrorMapping[exception.code.toLowerCase().trim()] ?? AuthErrorUnknown();
}

@immutable
class AuthErrorUnknown extends AuthError {
  AuthErrorUnknown()
      : super(
          dialogTitle: LocaleKeys.e104_error_unKnownError_dialogTitle.tr(),
          dialogDescription: LocaleKeys.e104_error_unKnownError_dialogDescriptiion.tr(),
        );
}

//* auth/no-current-user

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  AuthErrorNoCurrentUser()
      : super(
          dialogTitle: LocaleKeys.e104_error_noCurrentUser_dialogTitle.tr(),
          dialogDescription: LocaleKeys.e104_error_noCurrentUser_dialogDescription.tr(),
        );
}

//* auth/requires-recent-login

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  AuthErrorRequiresRecentLogin()
      : super(
          dialogTitle: LocaleKeys.e104_error_requiresRecentLogin_dialogTitle.tr(),
          dialogDescription: LocaleKeys.e104_error_requiresRecentLogin_dialogDescription.tr(),
        );
}

//* auth/operation-not-allowed

@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  AuthErrorOperationNotAllowed()
      : super(
          dialogTitle: LocaleKeys.e104_error_operationNotAllowed_dialogTitle.tr(),
          dialogDescription: LocaleKeys.e104_error_operationNotAllowed_dialogDescription.tr(),
        );
}

//* auth/user-not-found

@immutable
class AuthErrorUserNotFound extends AuthError {
  AuthErrorUserNotFound()
      : super(
          dialogTitle: LocaleKeys.e104_error_userNotFound_dialogTitle.tr(),
          dialogDescription: LocaleKeys.e104_error_userNotFound_dialogDescription.tr(),
        );
}

//* auth/weak-password

@immutable
class AuthErrorWeakPassword extends AuthError {
  AuthErrorWeakPassword()
      : super(
          dialogTitle: LocaleKeys.e104_error_weakPassword_dialogTitle.tr(),
          dialogDescription: LocaleKeys.e104_error_weakPassword_dialogDescription.tr(),
        );
}

//* auth/invalid-email

@immutable
class AuthErrorInvalidEmail extends AuthError {
  AuthErrorInvalidEmail()
      : super(
          dialogTitle: LocaleKeys.e104_error_invalidEmail_dialogTitle.tr(),
          dialogDescription: LocaleKeys.e104_error_invalidEmail_dialogDescription.tr(),
        );
}

//* auth/email-already-in-use

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  AuthErrorEmailAlreadyInUse()
      : super(
          dialogTitle: LocaleKeys.e104_error_emailAlreadyInUse_dialogTitle.tr(),
          dialogDescription: LocaleKeys.e104_error_emailAlreadyInUse_dialogDescription.tr(),
        );
}
