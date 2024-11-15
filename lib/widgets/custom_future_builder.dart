import 'package:app_tienda_comida/utils/is_admin.dart';
import 'package:flutter/material.dart';

FutureBuilder customFutureBuilder({required Widget child}) {
  return FutureBuilder(
    future: AuthService().isAdmin(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting ||
          snapshot.hasError) {
        return Container();
      } else if (snapshot.data) {
        return child;
      } else {
        return Container();
      }
    },
  );
}
