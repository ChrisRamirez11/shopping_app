import 'dart:async';

import 'package:app_tienda_comida/utils/bloc/loginBloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _confirmarPasswordController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  final _nameController = BehaviorSubject<String>();
  final _surnameController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();
  final _directionController = BehaviorSubject<String>();
  final _privateEmailController = BehaviorSubject<String>();
  final _registrationEmailController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);
  Stream<String> get confirmarPasswordStream => _passwordController.hasValue
      ? _confirmarPasswordController.stream
          .transform(validarConfirmarPassword(password))
      : _confirmarPasswordController.stream
          .transform(validarConfirmarPassword(''));

  Stream<String> get nameStream =>
      _nameController.stream.transform(validarNombre);
  Stream<String> get surnameStream =>
      _surnameController.stream.transform(validarApellidos);
  Stream<String> get phoneStream =>
      _phoneController.stream.transform(validarTlf);
  Stream<String> get directionStream =>
      _directionController.stream.transform(validarDir);
  Stream<String> get privateEmailStream =>
      _privateEmailController.stream.transform(validarEmail);
  Stream<String> get registrationEmailStream =>
      _registrationEmailController.stream.transform(validarEmail);

  // Insertar valores al Stream
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeConfirmarPassword =>
      _confirmarPasswordController.sink.add;

  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeSurname => _surnameController.sink.add;
  Function(String) get changePhone => _phoneController.sink.add;
  Function(String) get changeDirection => _directionController.sink.add;
  Function(String) get changePrivateEmail => _privateEmailController.sink.add;
  Function(String) get changeRegistrationEmail =>
      _registrationEmailController.sink.add;

  // Obtener  el último valor ingresado por los streams
  String get password => _passwordController.value;
  String get connfirmarPassword => _confirmarPasswordController.value;

  String get name => _nameController.value;
  String get surname => _surnameController.value;
  String get phone => _phoneController.value;
  String get direction => _directionController.value;
  String get privateEmail => _privateEmailController.value;
  String get registrationEmail => _registrationEmailController.value;

  // Combinación de Streams con RXDart'
  Stream<bool> get loginFormValidStream =>
      Rx.combineLatest2(nameStream, phoneStream, (n, p) => true);

  Stream<bool> get registerFormValidStream => Rx.combineLatest3(
      nameStream, confirmarPasswordStream, passwordStream, (n, ln, p) => true);
  Stream<bool> get createClientFormValidStream => Rx.combineLatest6(
        nameStream,
        surnameStream,
        phoneStream,
        directionStream,
        privateEmailStream,
        registrationEmailStream,
        (a, b, c, d, e, f) => true,
      );

  dispose() {
    _passwordController.close();
    _confirmarPasswordController.close();

    _nameController.close();
    _surnameController.close();
    _phoneController.close();
    _directionController.close();
    _privateEmailController.close();
    _registrationEmailController.close();
  }
}
