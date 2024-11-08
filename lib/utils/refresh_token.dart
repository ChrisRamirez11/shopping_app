import 'package:app_tienda_comida/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

refreshToken() async {
  try {
    await supabase.from('products').select();
  } catch (e) {
    if (e is PostgrestException && e.code == 'PGRST301') {
      await supabase.auth.refreshSession();
    }
  }
}
