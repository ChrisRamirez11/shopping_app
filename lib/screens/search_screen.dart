import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>>? _results;
  String _input = '';

  void _onSearchFieldChanged(String value) async {
    setState(() {
      _input = value;
    });

    if (_input.isNotEmpty) {
      final results = await searchProducts(_input);
      setState(() {
        _results = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: secondary,
          backgroundColor: primary,
          title: TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            onChanged: _onSearchFieldChanged,
            decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Buscar',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _results?.length ?? 0,
                itemBuilder: (context, index) {
                  final product = Product.fromJson(_results![index]);
                  return getListTile(product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  searchProducts(String input) async {
    try {
      final response =
          await supabase.from('products').select().ilike('name', '%$input%');
      return response;
    } catch (e) {
      throw 'Error $e';
    }
  }

  Widget getListTile(Product product) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Center(
        child: ListTile(
          leading: SizedBox(width: 40, height: 40, child: _loadImage(product)),
          title: Text(
            product.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: () => displayButtomSheet(context, product),
        ),
      ),
    );
  }
}

Future displayButtomSheet(BuildContext context, Product product) async {
  return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(400, 40),
              topRight: Radius.elliptical(400, 40))),
      builder: (context) => CustomizedBottomSheet(product: product));
}

_loadImage(product) {
  if (product.pic.isNotEmpty) {
    return CachedNetworkImage(
      cacheManager: null,
      imageUrl: product.pic,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  } else {
    return const Image(
      image: AssetImage('assets/images/no-image.png'),
    );
  }
}
