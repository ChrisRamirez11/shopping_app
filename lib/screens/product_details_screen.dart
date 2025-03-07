import 'package:app_tienda_comida/provider/carrito_provider.dart';
import 'package:app_tienda_comida/utils/cart_addition.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/producto.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String description = _getDescription(product.description);
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: secondary,
          backgroundColor: primary,
          title: Text(
            product.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.66,
                  width: double.infinity,
                  child: SheetBottomWidget(
                    product: product,
                    onAgregar: () {
                      cartAddition(context, product, cartProvider);
                    },
                    descripcion: description,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDescription(String des) {
    return des.isEmpty ? '-Sin Descripción-' : des;
  }
}

class SheetBottomWidget extends StatelessWidget {
  final Product product;
  final String descripcion; // Descripción del producto
  final Function() onAgregar; // Callback para añadir un elemento

  const SheetBottomWidget({
    Key? key,
    required this.product,
    required this.onAgregar,
    required this.descripcion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 14,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Hero(
                tag: '${product.id}',
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: _loadImage(product),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '#${product.type}',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
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
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SingleChildScrollView(
                            child: Text(
                              'Descripción:\n$descripcion',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text('\$${product.price.toString()}')),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(secondary.withOpacity(0.9)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)))),
                onPressed: onAgregar,
                icon: const Icon(Icons.add),
                label: const Text('Añadir',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _loadImage(Product product) {
    String pic = product.pic;

    if (pic.isNotEmpty) {
      return CustomImageWidget(imageUrl: product.pic);
    } else {
      return const Image(
          fit: BoxFit.cover, image: AssetImage('assets/images/no-image.png'));
    }
  }
}
