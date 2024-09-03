import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/producto.dart';

class CustomizedBottomSheet extends StatefulWidget {
  final Product product;
  const CustomizedBottomSheet({super.key, required this.product});

  @override
  State<CustomizedBottomSheet> createState() => _CustomizedBottomSheetState();
}

class _CustomizedBottomSheetState extends State<CustomizedBottomSheet> {
  @override
  Widget build(BuildContext context) {
    Product product = widget.product;

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
                    product: product,
                    onAgregar: () {},
                    onEliminar: () {},
                    descripcion: product.description),
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
  final Product product;
  final String descripcion; // Descripción del producto
  final Function() onAgregar; // Callback para añadir un elemento
  final Function() onEliminar; // Callback para eliminar un elemento
  // Callback para eliminar un producto

  const SheetBottomWidget(
      {Key? key,
      required this.product,
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
                child: CachedNetworkImage(
                  imageUrl: product.pic,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ))),
        Center(
          child: Text(
            product.name,
            style: const TextStyle(fontSize: 20),
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
          child: Text(product.price.toString()),
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
