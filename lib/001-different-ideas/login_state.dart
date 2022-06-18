import 'package:equatable/equatable.dart';

import 'dummy_model.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final DummyModel? model;
  // possible usage
  final bool isCompleted;

  const LoginState({
    required this.isLoading,
    this.model,
    this.isCompleted = false,
  });

  const LoginState.empty()
      : isLoading = false,
        model = null,
        isCompleted = false;

  @override
  List<Object?> get props => [isLoading, model];

  LoginState copyWith({
    bool? isLoading,
    DummyModel? model,
    bool? isCompleted,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
      isCompleted: isCompleted ?? false,
    );
  }
}
