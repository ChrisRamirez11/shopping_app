import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/utils/theme.dart';
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
    return Scaffold(
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
                final product = _results![index];
                return ListTile(title: Text(product['name']));
              },
            ),
          ),
        ],
      ),
    );
  }

  searchProducts(String input) async {
    final response =
        await supabase.from('products').select().ilike('name', '%$input%');

    return response;
  }
}
