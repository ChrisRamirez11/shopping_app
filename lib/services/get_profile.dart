import 'package:app_tienda_comida/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>> getProfile() async {
  try {
    final userId = supabase.auth.currentUser!.id;
    final profile =
        await supabase.from('profiles').select().eq('id', userId).single();
    return profile;
  } on AuthException catch (error) {
    throw error.message;
  } catch (error) {
    throw 'Error inseperado ocurrido $error';
  }
}
