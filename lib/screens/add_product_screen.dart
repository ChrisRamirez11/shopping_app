import 'dart:async';
import 'dart:convert';

import 'package:app_tienda_comida/models/Producto.dart';
import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/screens/home_screen.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductSecreen extends StatefulWidget {
  final Product? product;
  const AddProductSecreen({super.key, this.product});

  @override
  State<AddProductSecreen> createState() => _AddProductSecreenState();
}

class _AddProductSecreenState extends State<AddProductSecreen> {
  bool _saving = false;
  String pic = '';
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductsProviderSupabase productProvider = ProductsProviderSupabase();
  late Product product;

  @override
  void initState() {
    if (widget.product != null) {
      product = widget.product!;
    } else {
      product = new Product(
          id: 0, name: '', type: '', price: 1, availability: true, pic: '');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          foregroundColor: secondary,
          backgroundColor: primary,
          actions: [
            IconButton(
                onPressed: () {
                  _selectImage(ImageSource.gallery);
                },
                icon: Icon(
                  Icons.photo,
                  color: secondary,
                )),
            IconButton(
                onPressed: () {
                  _selectImage(ImageSource.camera);
                },
                icon: Icon(
                  Icons.camera_alt,
                  color: secondary,
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _createPicContainer(),
                  SizedBox(
                    height: 10,
                  ),
                  _nameField(),
                  _typeField(),
                  _priceField(),
                  _availabilityField(),
                  _createButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _nameField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(labelText: 'Nombre del producto'),
      onSaved: (newValue) => product.name = newValue!,
      validator: (value) {
        if (value!.length < 1) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  TextFormField _typeField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(labelText: 'Tipo de producto'),
      onSaved: (newValue) => product.type = newValue!,
      validator: (value) {
        if (value!.length < 1) {
          return 'Ingrese el tipo de producto';
        } else {
          return null;
        }
      },
    );
  }

  TextFormField _priceField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Precio del producto'),
      onSaved: (newValue) => product.price = double.parse(newValue!),
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Solo numeros para el precio';
        }
      },
    );
  }

  _availabilityField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SwitchListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text('Disponibilidad'),
          value: product.availability,
          onChanged: (value) => setState(() {
                product.availability = value;
              })),
    );
  }

  _createButton() {
    return ElevatedButton(
      onPressed: _saving ? null : () => _submit(),
      child: Text("Guardad"),
      style: ButtonStyle(
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
    );
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    setState(() {
      _saving = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Guardando'));
    Timer(Duration(milliseconds: 1500), () {
      ScaffoldMessenger.of(context)
          .showSnackBar(_showSnackBar('Registro Guardado'));
      if (widget.product == null) {
        productProvider.insertProduct(context, product);
      } else {
        productProvider.updateProduct(context, product);
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeSreen(),
          ));
    });
  }

  _createPicContainer() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset(1, 3),
            blurRadius: 4,
            spreadRadius: 2,
            color: Colors.black38)
      ]),
      child: Image(
        image: _loadImage(),
        height: 300,
        fit: BoxFit.cover,
      ),
    );
  }

  _selectImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      try {
        List<int> imageData = await pickedFile.readAsBytes();
        pic = base64Encode(imageData);
        setState(() {});
      } catch (e) {
        print("Error reading file: $e");
      }
    }
  }

  _loadImage() {
    if (pic.length > 0) {
      product.pic = pic;
      return MemoryImage(base64Decode(pic));
    } else {
      return const AssetImage('assets/images/no-image.png');
    }
  }

  _showSnackBar(String s) {
    return SnackBar(
      content: Text(s),
      duration: Duration(milliseconds: 1500),
    );
  }
}
