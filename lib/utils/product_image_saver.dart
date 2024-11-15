import 'dart:io';

import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/utils/scaffold_error_msg.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductImageSaver {
  BuildContext context;
  Product product;
  XFile imageFile;
  ProductImageSaver(
      {required this.context, required this.product, required this.imageFile});

  Future<void> productImageUpload() async {
    String imageName = '${product.id.toString()}.png';

    if (imageFile.path.isNotEmpty) {
      File file;
      if (product.pic.isEmpty) {
        try {
          file = File.fromUri(Uri.parse(imageFile.path));
          await supabase.storage.from('pictures').upload(imageName, file);
          await _productImageURLSet(imageName);
        } catch (e) {
          scaffoldErrorMessage(context, e);
        }
      } else {
        try {
          file = File.fromUri(Uri.parse(imageFile.path));
          await supabase.storage.from('pictures').update(imageName, file);
        } catch (e) {
          scaffoldErrorMessage(context, e);
        }
      }
    }
  }

  Future<void> _productImageURLSet(imageName) async {
    product.pic =
        await supabase.storage.from('pictures').getPublicUrl(imageName);
    await ProductsProviderSupabase().updateProduct(context, product);
  }
}
