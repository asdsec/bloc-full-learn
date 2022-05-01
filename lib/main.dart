import 'package:bloc_full_learn/101/cubit/basic_string_state.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: BasicStringStateView(),
    );
  }
}
