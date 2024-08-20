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
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Acciones para ${widget.productName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Editar'),
              onTap: () => widget.onEdit(),
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Eliminar'),
              onTap: () => widget.onDelete(),
            ),
          ],
        ),
      ),
    );
  }
}
