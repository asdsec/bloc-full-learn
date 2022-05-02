import 'package:bloc_full_learn/101/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;

const person1Url = 'http://192.168.1.7:5500/api/person1.json';
const person2Url = 'http://192.168.1.7:5500/api/person2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final String url;
  final PersonsLoader loader;
  const LoadPersonAction({required this.url, required this.loader}) : super();
}
