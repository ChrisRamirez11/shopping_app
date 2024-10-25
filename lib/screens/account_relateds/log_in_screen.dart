import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/screens/account_relateds/account_management_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _redirecting = false;
  late final TextEditingController _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _googleNativeSignIn() async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '122831544722-odr9q2t813bhp2of7shchsumgc7p77t2.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '122831544722-cc9k2hnvjqrl62cc9svq6qafmb6hlb5a.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    final accessToken = googleAuth?.accessToken;
    final idToken = googleAuth?.idToken;

    if (accessToken == null) {
      log('No Access Token found.') ;
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }
try{
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
//TODO
}catch(e){
  throw 'Error inesperado $e';
}
  }

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (data) {
        if (_redirecting) return;
        final session = data.session;
        if (session != null) {
          _redirecting = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const AccountManagementScreen()),
          );
        }
      },
      onError: (error) {
        if (error is AuthException) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error.message),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            'Error inseperado ocurrido',
          )));
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Sign In', style: Theme.of(context).textTheme.bodyLarge,)),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            const Center(child: Text('Regístrese con Google')),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () async {
                if (!kIsWeb && Platform.isAndroid || Platform.isIOS) {
                  return _googleNativeSignIn();
                }
                await supabase.auth.signInWithOAuth(OAuthProvider.google);
              },
              child: const Text('Google Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
