import 'package:flutter/material.dart';

class OnHoverButton extends StatefulWidget {
  const OnHoverButton({super.key});

  @override
  State<OnHoverButton> createState() => _OnHoverButtonState();
}

class _OnHoverButtonState extends State<OnHoverButton> {
  Color color = Colors.amber;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(height: 100),
            ElevatedButton(
                onPressed: () {},
                onHover: (value) => setState(() {
                      value ? color = Colors.blue : color = Colors.amber;
                    }),
                child: Text("Hovered"),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(color))),
          ],
        ),
      ),
    );
  }
}
