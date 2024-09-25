import 'package:app_tienda_comida/utils/cart_addition.dart';
import 'package:app_tienda_comida/utils/theme.dart';
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
    String description = _getDescription(product.description);

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
                    onAgregar: () {
                      cartAddition(context, product);
                    },
                    descripcion: description),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDescription(String des) {
    if (des.isEmpty) {
      return '-Sin Descripción-';
    }
    return des;
  }
}

class SheetBottomWidget extends StatelessWidget {
  final Product product;
  final String descripcion; // Descripción del producto
  final Function() onAgregar; // Callback para añadir un elemento

  //TODO poner cuando esta o no esta en stock y la cantidad que hay

  const SheetBottomWidget(
      {Key? key,
      required this.product,
      required this.onAgregar,
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
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.19,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Positioned.fill(
                    child: Card(
                      color: primary.withOpacity(0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SingleChildScrollView(
                          child: Text(
                            'Descripción: \n$descripcion',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Center(
          child: Text('\$${product.price.toString()}'),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(secondary.withOpacity(0.9)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)))),
              onPressed: onAgregar,
              icon: const Icon(Icons.add),
              label: const Text(
                'Añadir',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
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
