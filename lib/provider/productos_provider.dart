import 'dart:convert';

import 'package:app_tienda_comida/models/Producto.dart';
import 'package:app_tienda_comida/utils/preferencias_usuario.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProductosProviders extends ChangeNotifier {
  ProductosProviders() {
    productos = getproducto();
  }
  //TODO: Cambiar URL
  final Dio dio = Dio();
  List<Product> productos = [];
  int productosPage = 0;

  PreferenciasUsuario prefs = PreferenciasUsuario();

  Future<String> _postproducto(Map<String, dynamic> data) async {
    final prefs = PreferenciasUsuario();

    var options = Options(
      method: 'POST',
      headers: {
        'Authorization': prefs.token,
      },
    );

    dio.options.contentType = 'application/json';

    dio.options.validateStatus = (status) {
      return status! < 500;
    };
    try {
      final response = await dio.post('', data: data, options: options);

      if (response.statusCode == 200 || response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al crear los datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }

  Future<String> _deleteproducto(
    int id,
  ) async {
    final prefs = PreferenciasUsuario();
    var options = Options(
      method: 'DELETE',
      headers: {
        'id': id.toString(),
        'Authorization': prefs.token,
      },
    );

    dio.options.contentType = 'application/json';

    dio.options.validateStatus = (status) {
      return status! < 500;
    };

    try {
      final response = await dio.delete('', options: options);

      if (response.statusCode == 200) {
        return 'Eliminado Con Exito';
      } else {
        return 'Error al Conectar con el Server:-${response.statusCode}';
      }
    } catch (e) {
      return 'Error al realizar la solicitud: $e';
    }
  }

  Future<String> _getJsonData({int page = 1}) async {
    final prefs = PreferenciasUsuario();
    var options = Options(
      method: 'GET',
      headers: {
        'Authorization': prefs.token,
      },
    );

    dio.options.contentType = 'application/json';

    dio.options.validateStatus = (status) {
      return status! < 500;
    };

    try {
      final response = await dio.get('', options: options);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al obtener los datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }

  Future<String> _patchproducto(Map<String, dynamic> data) async {
    final prefs = PreferenciasUsuario();
    var options = Options(
      method: 'PATCH',
      headers: {
        'Authorization': prefs.token,
      },
    );

    dio.options.contentType = 'application/json';

    dio.options.validateStatus = (status) {
      return status! < 500;
    };
    try {
      final response = await dio.patch('', data: data, options: options);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al obtener los datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  getproducto() async {
    //TODO:CAMBIAR POR EL URL CORRESPONDIENTE

    final jsonData = await _getJsonData(page: productosPage);
    final productoResponse = Product.fromRawJson(jsonData);

    notifyListeners();
    return productoResponse;
  }

  deleteproductos(int id) async {
    //TODO:CAMBIAR POR EL URL CORRESPONDIENTE
    final response = await _deleteproducto(id);
    if (response == 'Eliminado Con Exito') {
      //TODO:ACTUALIZAR productoTRAMITE
      notifyListeners();
      return response;
    }
  }

  patchproducto(
      String id, nombre, tipo, double precio, bool disponibilidad) async {
    final data = {
      "id": id,
      "nombre": nombre,
      "tipo": tipo,
      "precio": precio,
      "disponibilidad": disponibilidad
    };
    //TODO:CAMBIAR POR EL URL CORRESPONDIENTE
    final responseBody = await _patchproducto(data);

    final updateproductoJson = json.decode(responseBody);
    final updatedproducto = Product.fromJson(updateproductoJson);
//TODO:ACTUALIZAR producto

    notifyListeners();
  }

  postproducto(
      String id, nombre, tipo, double precio, bool disponibilidad) async {
    final data = {
      "id": id,
      "nombre": nombre,
      "tipo": tipo,
      "precio": precio,
      "disponibilidad": disponibilidad
    };
    //TODO:CAMBIAR POR EL URL CORRESPONDIENTE
    final responseBody = await _postproducto(data);

    // Suponiendo que el servidor devuelve el vuelo actualizado en formato JSON
    final updateproductoJson = json.decode(responseBody);
    final updatedproducto = Product.fromJson(updateproductoJson);
//TODO:ACTUALIZAR productoTRAMITE
    // Encuentra el índice del producto a actualizar
//  int indexToUpdate = productosItalianos.indexWhere((productoItaliano) => productoItaliano.id == updatedproducto.id);

//  // Si el producto existe en la lista, actualízalo
//  if (indexToUpdate != -1) {
//     productosItalianos[indexToUpdate] = updatedproducto;
//  }

    notifyListeners();
  }
}
