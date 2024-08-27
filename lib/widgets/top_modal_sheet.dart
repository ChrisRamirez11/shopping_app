import 'package:flutter/material.dart';

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
    bool multiSelect = false;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
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
    super.key,
    required this.widget,
  });

  final CustomizedTopShet widget;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => widget.onDelete(),
      child: const Row(
        children: [
          Text('Eliminar'),
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
    super.key,
    required this.widget,
  });

  final CustomizedTopShet widget;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => widget.onEdit(),
      child: const Row(
        children: [
          Text('Editar'),
          SizedBox(
            width: 4,
          ),
          Icon(Icons.edit),
        ],
      ),
    );
  }
}
