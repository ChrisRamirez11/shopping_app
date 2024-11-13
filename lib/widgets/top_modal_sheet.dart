import 'package:app_tienda_comida/provider/theme_provider.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomizedTopShet extends StatefulWidget {
  final String productName;
  final Function onEdit;
  final Function onDelete;
  const CustomizedTopShet(
      {super.key,
      required this.productName,
      required this.onEdit,
      required this.onDelete});

  @override
  State<CustomizedTopShet> createState() => _CustomizedTopShetState();
}

class _CustomizedTopShetState extends State<CustomizedTopShet> {
  @override
  Widget build(BuildContext context) {
    bool themeData = Provider.of<ThemeProvider>(context).themeData;
    bool multiSelect = false;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeData ? second2 : secondary,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (!multiSelect) _Editar(widget: widget),
            _Eliminar(widget: widget)
          ],
        ),
      ),
    );
  }
}

class _Eliminar extends StatelessWidget {
  const _Eliminar({
    required this.widget,
  });

  final CustomizedTopShet widget;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => widget.onDelete(),
      child: Row(
        children: [
          Text('Eliminar', style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(
            width: 4,
          ),
          Icon(Icons.delete),
        ],
      ),
    );
  }
}

class _Editar extends StatelessWidget {
  const _Editar({
    required this.widget,
  });

  final CustomizedTopShet widget;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => widget.onEdit(),
      child: Row(
        children: [
          Text('Editar', style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(
            width: 4,
          ),
          Icon(Icons.edit),
        ],
      ),
    );
  }
}
