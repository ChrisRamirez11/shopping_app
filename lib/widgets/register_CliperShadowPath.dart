import 'package:flutter/material.dart';
class SmallClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
   Path path_0 = Path();
    path_0.moveTo(size.width*1.0187500,size.height*-0.0021500);
    path_0.quadraticBezierTo(size.width*0.1055500,size.height*0.1532625,size.width*0.0072500,size.height*0.4053625);
    path_0.quadraticBezierTo(size.width*0.0819500,size.height*0.6802875,size.width*1,size.height*1);

return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
 return false;
  }
}
