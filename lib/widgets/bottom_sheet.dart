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
    return ClipShadowPath(
              shadow: const BoxShadow(
                  color: Colors.black,
                  offset: Offset(4, 4),
                  blurRadius: 4,
                  spreadRadius: 8),
              clipper: HomeScreenClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.yellow, Colors.amber])),
              ),
            );
  }
}