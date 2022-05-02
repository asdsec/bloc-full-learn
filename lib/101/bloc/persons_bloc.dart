import 'package:bloc_full_learn/101/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_actions.dart';

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) => length == other.length && {...this}.intersection({...other}).length == length;
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;
  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });
  @override
  String toString() => 'FetchResult (isRetrievedFromCache = $isRetrievedFromCache, person = $persons)';

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoringOrdering(other.persons) && isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode => Object.hash(persons, isRetrievedFromCache);
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonAction>(
      //? NOTE: [event] is the input of bloc; [emit] is the output of bloc
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          // we have the value in the cache
          final cachedPersons = _cache[url]!;
          final result = FetchResult(
            persons: cachedPersons,
            isRetrievedFromCache: true,
          );
          emit(result);
        } else {
          final loader = event.loader;
          final persons = await loader(url);
          _cache[url] = persons;
          final result = FetchResult(
            persons: persons,
            isRetrievedFromCache: false,
          );
          emit(result);
        }
      },
    );
  }
}
