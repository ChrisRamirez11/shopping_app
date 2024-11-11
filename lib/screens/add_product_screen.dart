import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/provider/product_list_provider.dart';
import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/utils/image_compressor.dart';
import 'package:app_tienda_comida/utils/scaffold_error_msg.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart' as provider;
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

  String? _selectedOption;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (!mounted) {
      return;
    }

    if (widget.product != null) {
      product = widget.product!;
      pic = product.pic;
      _selectedOption = product.type;
    } else {
      product = Product(
          id: 0,
          name: '',
          type: '',
          price: 0,
          availability: false,
          pic: '',
          quantity: 0,
          description: '');
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
                  _quantityField(),
                  const SizedBox(
                    height: 15,
                  ),
                  _availabilityField(),
                  const SizedBox(
                    height: 15,
                  ),
                  _descriptionField(),
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
      style: Theme.of(context).textTheme.labelMedium,
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
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
            ),
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(
                    'Ingrese el nuevo tipo de producto: ',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        style: Theme.of(context).textTheme.labelMedium,
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
                          child: const Text('Ok'),
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
                        )
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
      style: Theme.of(context).textTheme.labelMedium,
      initialValue: product.price.toString(),
      keyboardType:
          TextInputType.numberWithOptions(decimal: true, signed: false),
      decoration: const InputDecoration(
        labelText: 'Precio',
        border: OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        if (newValue != null) {
          String cleanedValue =
              newValue.replaceAll(',', '.').replaceAll('-', '');
          product.price = double.tryParse(cleanedValue) ?? 0.0;
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa un precio';
        }
        String cleanedValue = value.replaceAll(',', '.').replaceAll('-', '');
        if (utils.isNumeric(cleanedValue)) {
          return null;
        } else {
          return 'Solo números para el precio';
        }
      },
    );
  }

  TextFormField _quantityField() {
    bool enabled = !product.availability;
    return TextFormField(
      style: Theme.of(context).textTheme.labelMedium,
      enabled: enabled,
      initialValue: product.quantity.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      decoration: InputDecoration(
        enabled: enabled,
        labelText: 'Cantidad en stock',
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) => product.quantity = int.parse(newValue!),
      validator: (value) {
        if (utils.isNumeric(value!.trim())) {
          return null;
        } else {
          return 'Debe contener solo numeros';
        }
      },
    );
  }

  _availabilityField() {
    return SwitchListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: utils.getTexts(
            'Siempre en stock', Theme.of(context).textTheme.bodyMedium),
        value: product.availability,
        onChanged: (value) => setState(() {
              product.availability = value;
            }));
  }

  _descriptionField() {
    return TextFormField(
      style: Theme.of(context).textTheme.labelMedium,
      maxLines: 3,
      initialValue: product.description,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        contentPadding: const EdgeInsets.all(10),
        isCollapsed: product.description.isEmpty ? true : false,
        labelText: 'Descripción(opcional)',
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) => product.description = newValue!,
    );
  }

  _createButton() {
    return ElevatedButton(
      onPressed: _saving ? null : () => _submit(),
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(primary),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Text(
        "Guardar",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Future<void> _submit() async {
    if (mounted) {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();

      setState(() {
        _saving = true;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Guardando'));

        String imageName = '${product.name}${product.type}.png'..replaceAll(' ', '_');
        if (imageFile.path.isNotEmpty) {
          productImageUpload(imageName);
          productImageURLSet(imageName);
        }

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
    }
  }

  _createPicContainer() {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
        BoxShadow(
            offset: Offset(1, 3),
            blurRadius: 4,
            spreadRadius: 2,
            color: Colors.black38)
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          image: _loadImage(),
          height: 300,
          fit: BoxFit.contain,
        ),
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
        if(mounted){
          scaffoldErrorMessage(context, "Error reading file: $e");
        }
      }
    }
  }

  _loadImage() {
    if (pic.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(pic));
      } catch (e) {
        log('$e');
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
      try {
        file = File.fromUri(Uri.parse(imageFile.path));
        supabase.storage.from('pictures').upload(imageName, file);
      } catch (e) {
        if (mounted) {
          scaffoldErrorMessage(context, e);
        }
      }
    } else {
      if (widget.product!.pic.isEmpty) {
        try {
          file = File.fromUri(Uri.parse(imageFile.path));
          supabase.storage.from('pictures').upload(imageName, file);
          return;
        } catch (e) {
          if (mounted) {
            scaffoldErrorMessage(context, e);
          }
        }
      }
      try {
        file = File.fromUri(Uri.parse(imageFile.path));
        supabase.storage.from('pictures').update(imageName, file);
      } catch (e) {
        if (mounted) {
          scaffoldErrorMessage(context, e);
        }
      }
    }
  }

  void productImageURLSet(imageName) {
    product.pic = supabase.storage.from('pictures').getPublicUrl(imageName);
  }
}
