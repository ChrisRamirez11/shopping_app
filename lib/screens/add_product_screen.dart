import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_tienda_comida/provider/product_list_provider.dart';
import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/utils/image_compressor.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/producto.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;
  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductsProviderSupabase productProvider = ProductsProviderSupabase();
  late Product product;

  //picture
  bool _saving = false;
  String pic = '';
  late XFile imageFile = XFile.fromData(Uint8List.fromList([]));

  //DropDownButton
  String? _selectedOption;

  @override
  void initState() {
    if (widget.product != null) {
      product = widget.product!;
      pic = product.pic;
      _selectedOption = product.type;
    } else {
      product = Product(
          id: 0, name: '', type: '', price: 0, availability: true, pic: '');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = provider.Provider.of<ProductsListNotifier>(context);
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
                  const SizedBox(
                    height: 15,
                  ),
                  _nameField(),
                  const SizedBox(
                    height: 15,
                  ),
                  _productTypeRow(notifier),
                  const SizedBox(
                    height: 15,
                  ),
                  _priceField(),
                  const SizedBox(
                    height: 15,
                  ),
                  _availabilityField(),
                  const SizedBox(
                    height: 15,
                  ),
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
      initialValue: product.name,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
        labelText: 'Nombre del producto',
        border: OutlineInputBorder(),
      ),
      onSaved: (newValue) => product.name = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  _productTypeRow(ProductsListNotifier notifier) {
    String type = '';
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: _typeSelectorField(notifier.productsListNotifier),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            style: const ButtonStyle(
              shape: WidgetStatePropertyAll(ContinuousRectangleBorder()),
            ),
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(
                    'Ingrese el nuevo tipo de producto: ',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        onChanged: (value) => type = value,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de Producto',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              type.isEmpty
                                  ? null
                                  : {
                                      if (!notifier.productsListNotifier
                                          .contains(type))
                                        {
                                          notifier.addItem(type),
                                          setState(() {}),
                                          Navigator.of(context).pop()
                                        }
                                      else
                                        {Navigator.of(context).pop()}
                                    };
                            },
                            child: const Text('Ok'))
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  DropdownButtonFormField _typeSelectorField(List<String> notifier) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Seleccione tipo de producto',
        border: OutlineInputBorder(),
      ),
      value: _selectedOption,
      items: notifier.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (String? nuevaOpcion) {
        setState(() {
          _selectedOption = nuevaOpcion.toString();
          product.type = _selectedOption.toString();
        });
      },
      validator: (value) {
        if (value != null) {
          return null;
        } else {
          return 'Seleccione el tipo de producto';
        }
      },
    );
  }

  TextFormField _priceField() {
    return TextFormField(
      initialValue: product.price.toString(),
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Precio del producto',
        border: OutlineInputBorder(),
      ),
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
    return SwitchListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Disponibilidad'),
        value: product.availability,
        onChanged: (value) => setState(() {
              product.availability = value;
            }));
  }

  _createButton() {
    return ElevatedButton(
      onPressed: _saving ? null : () => _submit(),
      style: ButtonStyle(
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
      child: Text(
        "Guardar",
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    setState(() {
      _saving = true;
    });

    if (await productProvider.productNameExists(context, product.name) &&
        widget.product == null) {
      (timeStamp) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Center(
                  child: Text(
                'ERROR',
                style: TextStyle(color: Colors.red.shade300),
              )),
              content: const Text('El producto ya existe'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'))
              ],
            ),
          );
      return;
    }

    String imageName = '${product.name}.png'..replaceAll(' ', '_');
    if (imageFile.path.isNotEmpty) {
      productImageUpload(imageName);
      productImageURLSet(imageName);
    }

    ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Guardando'));
    Timer(const Duration(milliseconds: 1500), () {
      ScaffoldMessenger.of(context)
          .showSnackBar(_showSnackBar('Registro Guardado'));
      if (widget.product == null) {
        productProvider.insertProduct(context, product);
      } else {
        productProvider.updateProduct(context, product);
      }
      Navigator.of(context).pop();
    });
  }

  _createPicContainer() {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
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
        XFile compressedImage = await compressImage(imageFile: pickedFile);
        List<int> imageData = await compressedImage.readAsBytes();

        setState(() {
          imageFile = compressedImage;
          pic = base64Encode(imageData);
        });
      } catch (e) {
        log("Error reading file: $e");
      }
    }
  }

  _loadImage() {
    if (pic.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(pic));
      } catch (e) {
        return NetworkImage(pic);
      }
    } else {
      return const AssetImage('assets/images/no-image.png');
    }
  }

  _showSnackBar(String s) {
    return SnackBar(
      content: Text(s),
      duration: const Duration(milliseconds: 1500),
    );
  }

  void productImageUpload(imageName) {
    File file;
    if (widget.product == null) {
      file = File.fromUri(Uri.parse(imageFile.path));
      Supabase.instance.client.storage.from('pictures').upload(imageName, file);
    } else {
      if (widget.product!.pic.isEmpty) {
        file = File.fromUri(Uri.parse(imageFile.path));
        Supabase.instance.client.storage
            .from('pictures')
            .upload(imageName, file);
        return;
      }
      try {
        file = File.fromUri(Uri.parse(imageFile.path));
        Supabase.instance.client.storage
            .from('pictures')
            .update(imageName, file);
      } catch (e) {
        log('$e');
      }
    }
  }

  void productImageURLSet(imageName) {
    product.pic = Supabase.instance.client.storage
        .from('pictures')
        .getPublicUrl(imageName);
  }
}
