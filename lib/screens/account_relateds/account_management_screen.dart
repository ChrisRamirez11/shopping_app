import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/provider/get_profile.dart';
import 'package:app_tienda_comida/screens/account_relateds/log_in_screen.dart';
import 'package:app_tienda_comida/utils/preferencias_usuario.dart';
import 'package:app_tienda_comida/utils/utils.dart';
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
  final prefs = PreferenciasUsuario();

  bool _loading = true;

  Future<void> _getProfile() async {
    try {
      final data = await getProfile(context);
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

    if (_cellphoneController.text.contains(RegExp(r'[,.]'))) {
      _cellphoneController.text =
          _cellphoneController.text.replaceAll(RegExp(r'[,.]'), '');
    }

    if (!isNumeric(_cellphoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Telèfono solo debe contener nùmeros')),
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
      'email': user.email
    };
    try {
      await supabase.from('profiles').upsert(updates);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Perfil actualizado con éxito'),
        ));
        Navigator.of(context).pop();
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
          title: Text(
            'Perfil',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            TextFormField(style: Theme.of(context).textTheme.labelLarge,
              controller: _fullNameController,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Nombre y Apellido',
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(style: Theme.of(context).textTheme.labelLarge,
              maxLines: 2,
              controller: _directionController,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Dirección',
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(style: Theme.of(context).textTheme.labelLarge,
              keyboardType: TextInputType.number,
              controller: _cellphoneController,
              decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  labelText: 'Teléfono de Contacto'),
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
