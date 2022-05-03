import '../../public/language/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../dialogs/generic_dialog.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;

  const LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final email = emailController.text;
        final password = passwordController.text;
        if (email.isEmpty || password.isEmpty) {
          //? NOTE: actually this function return future so normally we need to
          //? put [await] in front of it but, here we do not regard the outcome
          showGenericDialog<bool>(
            context: context,
            title: LocaleKeys.e102_emailOrPasswordEmptydialogTitle.tr(),
            content: LocaleKeys.e102_emailOrPasswordEmptyDescription.tr(),
            optionBuilder: () => {
              LocaleKeys.e102_ok.tr(): true,
            },
          );
        } else {
          onLoginTapped(
            email,
            password,
          );
        }
      },
      child: Text(LocaleKeys.e102_login.tr()),
    );
  }
}
