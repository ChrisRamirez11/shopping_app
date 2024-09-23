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
  /*
  TODO hay que poner lo de que si no tiene descripcion que diga sin descripcion,
  -que si no esta en stock que diga sin stock, el boton que sea para añadir al carrito,
  -quitar los botones esos del final y probablemente poner ahi el boton de añadir al carrito
  -si no esta en stock no se puede añadir(esto tambien hacerlo en grid_view_widget en add)
  */
  @override
  Widget build(BuildContext context) {
    Product product = widget.product;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
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
            padding: const EdgeInsets.all(25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 200,
                  width: 300,
                  child: _loadImage(product),
                ))),
        Center(
          child: Text(
            product.name,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.19,
                child: Text(
                  'Descripción: $descripcion',
                  style: const TextStyle(fontSize: 16),
                ))),
        Center(
          child: Text(product.price.toString()),
        ), // Muestra la descripción del producto
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: onAgregar,
              icon: const Icon(Icons.add),
              label: const Text('Añadir'),
            ),
            ElevatedButton.icon(
              onPressed: onEliminar,
              icon: const Icon(Icons.remove),
              label: const Text('Eliminar'),
            ),
          ],
        )
      ],
    );
  }

  _loadImage(Product product) {
    String pic = product.pic;

    if (pic.isNotEmpty) {
      return CachedNetworkImage(
        cacheManager: null,
        fit: BoxFit.contain,
        imageUrl: pic,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return const Image(
        fit: BoxFit.contain,
        image: AssetImage('assets/images/no-image.png'),
      );
    }
  }
}
