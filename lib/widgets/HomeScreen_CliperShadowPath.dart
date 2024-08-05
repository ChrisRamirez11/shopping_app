import 'package:flutter/material.dart';
class HomeScreenClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
   Path path_0 = Path();
    path_0.moveTo(size.width*-0.0020000,size.height*0.5637500);
    path_0.quadraticBezierTo(size.width*0.1340000,size.height*0.5276375,size.width*0.5029500,size.height*0.5246750);
    path_0.quadraticBezierTo(size.width*0.8765000,size.height*0.5316000,size.width*1.0025000,size.height*0.5635000);
    path_0.lineTo(size.width*1.0058500,size.height*1.0041750);
    path_0.lineTo(size.width*-0.0071000,size.height*1.0015125);

return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
 return false;
  }
}
