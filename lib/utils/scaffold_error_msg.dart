import 'package:flutter/material.dart';

scaffoldErrorMessage(BuildContext context, e){
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Ha ocurrido un error. \n$e'),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
}