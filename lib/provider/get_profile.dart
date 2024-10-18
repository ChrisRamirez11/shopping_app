import 'package:app_tienda_comida/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>> getProfile(context) async {
  
try {
      final userId = supabase.auth.currentUser!.id;
      final profile =
          await supabase.from('profiles').select().eq('id', userId).single();
      return profile;
    } on AuthException catch (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
            return Future.value({});
    } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Error inseperado ocurrido',
        )));
      return Future.value({});
    }
  }
