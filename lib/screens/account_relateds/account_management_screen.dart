import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/screens/account_relateds/log_in_screen.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  State<AccountManagementScreen> createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  final _fullNameController = TextEditingController();
  final _directionController = TextEditingController();
  final _cellphoneController = TextEditingController();

  bool _flag = false;

  bool _loading = true;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();
      _fullNameController.text = (data['fullName'] ?? '') as String;
      _directionController.text = (data['direction'] ?? '') as String;
      _cellphoneController.text = (data['cellphone'] ?? '') as String;
    } on PostgrestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Error inseperado ocurrido',
        )));
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });

    // Validate non-empty fields
    if (_fullNameController.text.isEmpty ||
        _directionController.text.isEmpty ||
        _cellphoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      setState(() {
        _loading = false;
      });
      return;
    }

    final fullName = _fullNameController.text.trim();
    final website = _directionController.text.trim();
    final cellphone = _cellphoneController.text.trim();
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'fullName': fullName,
      'direction': website,
      'cellphone': cellphone,
    };
    try {
      await supabase.from('profiles').upsert(updates);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Perfil actualizado con éxito'),
        ));
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error inesperado ocurrido'),
        ));
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _flag = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Error inseperado ocurrido',
        )));
      }
    } finally {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _directionController.dispose();
    _cellphoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit, color: !_flag ? primary : secondary),
              onPressed: () {
                setState(() {
                  !_flag ? _flag = true : _flag = false;
                });
              },
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            TextFormField(
              enabled: _flag,
              controller: _fullNameController,
              decoration: InputDecoration(
                  labelText: 'Nombre y Apellido', enabled: _flag),
            ),
            const SizedBox(height: 18),
            TextFormField(
              maxLines: 2,
              enabled: _flag,
              controller: _directionController,
              decoration:
                  InputDecoration(labelText: 'Dirección', enabled: _flag),
            ),
            const SizedBox(height: 18),
            TextFormField(
              enabled: _flag,
              controller: _cellphoneController,
              decoration: InputDecoration(
                  labelText: 'Teléfono de Contacto', enabled: _flag),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _loading ? null : _updateProfile,
              child: Text(_loading ? 'Guardando...' : 'Actualizar'),
            ),
            const SizedBox(height: 18),
            TextButton(onPressed: _signOut, child: const Text('Sign Out')),
          ],
        ),
      ),
    );
  }
}
