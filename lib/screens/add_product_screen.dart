import 'package:app_tienda_comida/models/Producto.dart';
import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/utils/utils.dart' as utils;
import 'package:flutter/material.dart';

class AddProductSecreen extends StatefulWidget {
  @override
  State<AddProductSecreen> createState() => _AddProductSecreenState();
}

class _AddProductSecreenState extends State<AddProductSecreen> {
  final formKey = GlobalKey<FormState>();
  ProductsProviderSupabase productosProviders = ProductsProviderSupabase();
  Producto producto = new Producto(
      id: 0, nombre: '', tipo: '', precio: 1, disponibilidad: true);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
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
      onSaved: (newValue) => producto.nombre = newValue!,
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
      onSaved: (newValue) => producto.tipo = newValue!,
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
      onSaved: (newValue) => producto.precio = double.parse(newValue!),
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
        value: producto.disponibilidad,
        onChanged: (value) => setState(() {
              producto.disponibilidad = value;
            }));
  }

  _createButton() {
    return ElevatedButton(
      onPressed: () {
        _submit();
      },
      child: Text("Guardad"),
      style: ButtonStyle(
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
    );
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    productosProviders.insertProduct(producto.nombre, producto.tipo,
        producto.precio, producto.disponibilidad);
    // setState(() {
    //   _saving = true;
    // });
    // ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Guardando'));
    // Timer(Duration(milliseconds: 1500), () {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(_showSnackBar('Registro Guardado'));
    //   if (widget.pet == null) {
    //     petProvider.createPet(pet);
    //   } else {
    //     petProvider.editPet(pet);
    //   }
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => MainMenu(),
    //     ));
    // });
  }
}
