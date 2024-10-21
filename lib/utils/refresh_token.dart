 import 'dart:developer';

import 'package:app_tienda_comida/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

refreshToken() async {
  try {
    final resp = await supabase.from('products').select();
    log('refresh_token ${resp.length.toString()}');
  } catch (e) {
    if (e is PostgrestException && e.code == 'PGRST301') {
      await supabase.auth.refreshSession();
    }
  }
 }