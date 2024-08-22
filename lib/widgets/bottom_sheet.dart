import 'package:flutter/material.dart';

class CustomizedBottomSheet extends StatefulWidget {
  const CustomizedBottomSheet({super.key});

  @override
  State<CustomizedBottomSheet> createState() => _CustomizedBottomSheetState();
}

class _CustomizedBottomSheetState extends State<CustomizedBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.66,
                width: MediaQuery.of(context).size.width,
                child: SheetBottomWidget(
                  onAgregar: () {},
                  onEliminar: () {},
                  descripcion:
                      'Platano frito. Una receta facil, muy típica de latinoamérica. En España estamos más que acostumbrados a la guarnición de patatas fritas para acompañar nuestros platos. Hoy traemos una alternativa muy sabrosa',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SheetBottomWidget extends StatelessWidget {
// La cantidad actual del carrito
  final String descripcion; // Descripción del producto
  final Function() onAgregar; // Callback para añadir un elemento
  final Function() onEliminar; // Callback para eliminar un elemento
  // Callback para eliminar un producto

  const SheetBottomWidget(
      {Key? key,
      required this.onAgregar,
      required this.onEliminar,
      required this.descripcion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: EdgeInsets.all(25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/images/er.jpg'))),
        Center(
          child: Text(
            'Nombre del Producto',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
            padding: EdgeInsets.all(12),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.19,
                child: Text(
                  'Descripción: $descripcion',
                  style: TextStyle(fontSize: 16),
                ))),
        Center(
          child: Text('Precio: 420 cup'),
        ), // Muestra la descripción del producto
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: onAgregar,
              icon: Icon(Icons.add),
              label: Text('Añadir'),
            ),
            ElevatedButton.icon(
              onPressed: onEliminar,
              icon: Icon(Icons.remove),
              label: Text('Eliminar'),
            ),
          ],
        )
      ],
    );
  }
}
