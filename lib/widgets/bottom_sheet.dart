import 'package:app_tienda_comida/widgets/HomeScreen_CliperShadowPathdart';
import 'package:app_tienda_comida/widgets/clipShadowPath.dart';
import 'package:flutter/material.dart';

class CustomizedBottomSheet extends StatefulWidget {
  const CustomizedBottomSheet({super.key});

  @override
  State<CustomizedBottomSheet> createState() => _CustomizedBottomSheetState();
}

class _CustomizedBottomSheetState extends State<CustomizedBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      height: 100,
      child: Column(
        children: [
          SizedBox(height:20,),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: SheetCarritoWidget(cantidadCarrito: 2, onAgregar: (){}, onEliminar: () {
              
            },),
          ),
        ],
      ),
    );
                  
                
  }}

class SheetCarritoWidget extends StatelessWidget {
  final int cantidadCarrito; // La cantidad actual del carrito
  final Function() onAgregar; // Callback para añadir un elemento
  final Function() onEliminar; // Callback para eliminar un elemento

  const SheetCarritoWidget({
    Key? key,
    required this.cantidadCarrito,
    required this.onAgregar,
    required this.onEliminar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Cantidad en el carrito: $cantidadCarrito'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [ElevatedButton.icon(
            onPressed: () => onAgregar,
            icon: Icon(Icons.add),
            label: Text('Añadir'),
          ),
          ElevatedButton.icon(
            onPressed: () => onEliminar,
            icon: Icon(Icons.remove),
            label: Text('Eliminar'),
          ),],
          )
        ],
      ),
    );
  }
}