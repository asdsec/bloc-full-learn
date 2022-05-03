import '../../public/language/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordTextField({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: LocaleKeys.e102_enterYourPasswordHere.tr(),
      ),
    );
  }
}
