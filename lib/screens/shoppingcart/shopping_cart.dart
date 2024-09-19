import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/Producto.dart';
import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:app_tienda_comida/provider/cart_supabase_provider.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<Map<String, dynamic>>? mapList;
  int? quantity;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final userId = supabase.auth.currentSession!.user.id;
    CartSupabaseProvider cartSupabaseProvider = CartSupabaseProvider();

    return Drawer(
      width: size.width * 0.80,
      child: FutureBuilder(
          future: cartSupabaseProvider.getCart(userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!;
            return Column(
              children: [
                getTopBar(size),
                getListView(data, size),
              ],
            );
          }),
    );
  }

  Widget getListView(List<CartItem> data, Size size) {
    return SizedBox(
      height: size.height * 0.80,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10),
        itemCount: data.length,
        itemBuilder: (context, index) => getListTile(data[index]),
      ),
    );
  }

  Widget getTopBar(Size size) {
    //TODO Edit this
    return Container(
      color: primary,
      height: size.height * 0.065,
      child: Center(
        child: Text(
          'Carrito',
          style: Theme.of(context).textTheme.titleLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget getListTile(CartItem cartItem) {
    return FutureBuilder<Product>(
      future: fetchProduct(cartItem.productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Icon(Icons.error));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Producto no encontrado"));
        }

        Product product = snapshot.data!;
        int quantity = cartItem.quantity;
        return Card(
            color: Theme.of(context).cardColor,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: product.pic,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '\$${product.price}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          IconButton(
                            iconSize: 24,
                            icon: const Icon(Icons.delete),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          IconButton(
                            iconSize: 24,
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                quantity--;
                              });
                            },
                          ),
                          Text('$quantity'),
                          IconButton(
                            iconSize: 24,
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ]),
            ));
      },
    );
  }
}

//functions
//

Future<Product> fetchProduct(int productId) async {
  final response =
      await supabase.from('products').select().eq('id', productId).single();
  return Product.fromJson(response);
}
