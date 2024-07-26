
import 'dart:ui';

import 'package:app_tienda_comida/provider/onHoverProvider.dart';
import 'package:app_tienda_comida/screens/home_screen.dart';
import 'package:app_tienda_comida/utils/bloc/loginBloc/provider.dart';
import 'package:app_tienda_comida/utils/preferencias_usuario.dart';
import 'package:app_tienda_comida/utils/route_animation.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/clipShadowPath.dart';
import 'package:app_tienda_comida/widgets/register_CliperShadowPath.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
    final prefs = PreferenciasUsuario();
Widget _loginForm(BuildContext context) {

  final bloc = ProviderP.of(context);
    final size = MediaQuery.of(context).size;

    return  Container(
          height: size.height*0.50,
          width: size.width * 0.85,
          margin: const EdgeInsets.symmetric(vertical: 30.0),
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          decoration: BoxDecoration(
              color:const Color.fromARGB(213, 254, 254, 254),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 0.5),
                    spreadRadius: 3.0)
              ]),
          child: RawScrollbar(
            radius:const Radius.circular(4),
            thumbVisibility: true,
          thumbColor: theme.primaryColor,
            child: SingleChildScrollView(
              
              child: Column(
                children: [
                  Text(
                    'Don Pepito',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                    
                        fontSize: 25.0,
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  _crearName(bloc),
                  const SizedBox(
                    height: 15.0,
                  ),
                  _crearNumero(bloc),
                  const SizedBox(
                    height: 15.0,
                  ),
                 
                  _crearBoton(bloc,context)
                ],
              ),
            ),
          ),
        );
  }
Widget _crearName(LoginBloc bloc) {
  return StreamBuilder(
    stream: bloc.nameStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Escriba su Nombre',
            labelText: 'Nombre y Apellidos',
            errorText: snapshot.error?.toString(),
            suffixIcon: const Icon(Icons.account_circle_sharp),
          ),
          onChanged: (value) => bloc.changeName(
              value), //también se puede utilizar "bloc.changeEmail" en su lugar
        ),
      );
    },
  );
} 
Widget _crearNumero(LoginBloc bloc) {
  return StreamBuilder(
    stream: bloc.phoneStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            hintText: '+53 ## ## ## ##',
            labelText: 'Número de Teléfono',
            errorText: snapshot.error?.toString(),
            suffixIcon: const Icon(Icons.phone),
          ),
          onChanged: (value) => bloc.changePhone(
              value), //también se puede utilizar "bloc.changeEmail" en su lugar
        ),
      );
    },
  );
} 
Widget _crearBoton(LoginBloc bloc,BuildContext context) {
  
     var onhover = Provider.of<OnHoverProvider>(context);
    
    return StreamBuilder(
      
      stream: bloc.loginFormValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          
          onFocusChange: (event) => setState(() {
    super.setState(() {
               onhover.setColor(event);//
            }); 
          }),
          onHover: (event) => setState(() {
    super.setState(() {
               onhover.setColor(event);//
            }); 
          }),
          
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: onhover.onHover?onhover.primarycolor:onhover.secundarycolor
              ,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 0.0),
          onPressed: snapshot.hasData ? () {
          prefs.user = bloc.name;
          prefs.phoneNumber = bloc.phone;
          Navigator.pushReplacement(context,  crearRuta(const HomeSreen(), const Duration(microseconds: 700)));
          } : null,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: const Text('Ingresar'),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
      var size =MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
      height: size.height,
      width: size.width,
      child:  Stack(
        children: [
          const _FondoRegister(),
        Center(
          child: _loginForm(context),
        )
        ],
      ),
    ),
    );
  }
  
}


class _FondoRegister extends StatelessWidget {
  const _FondoRegister();

  @override
  Widget build(BuildContext context) {
    return Stack(
      
      children: [
        Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                
                colors: [Colors.redAccent ,Colors.red,])
            ),
            ),
        
        Align(
          alignment: Alignment.centerRight,
          child: ClipShadowPath(
            shadow: const BoxShadow(
              color:  Colors.black,
              offset: Offset(4, 4),
              blurRadius: 4,
              spreadRadius: 8
            ),
          clipper: SmallClipper(),
          child: Container(
             width: MediaQuery.of(context).size.width*0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                
                colors: [Colors.yellow,Colors.amber])
            ),
          ),
        )),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1,sigmaY: 1),
            child: Container(
              decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                
                colors: [Colors.transparent,Colors.black12])
            ),
            ),
            ),
        )
       
      ],
    );
  }
}
class _DatosUsuarioForm extends StatefulWidget {
  const _DatosUsuarioForm();

  @override
  State<_DatosUsuarioForm> createState() => __DatosUsuarioFormState();
}

class __DatosUsuarioFormState extends State<_DatosUsuarioForm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
