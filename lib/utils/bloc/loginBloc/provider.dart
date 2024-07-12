import 'package:flutter/material.dart';

import 'login_bloc.dart';
export 'login_bloc.dart';

class ProviderP extends InheritedWidget {
  static ProviderP? _instance;

  factory ProviderP({Key? key, Widget? child}) {
    _instance ??= ProviderP._internal(key: key, child: child!);
    return _instance!;
  }

  ProviderP._internal({super.key, required super.child});

  final loginBloc = LoginBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderP>()
            as ProviderP)
        .loginBloc;
  }
}
