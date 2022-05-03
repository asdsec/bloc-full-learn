import '../../public/language/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController emailController;

  const EmailTextField({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: LocaleKeys.e102_enterYourEmailHere.tr(),
      ),
    );
  }
}
