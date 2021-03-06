import 'package:flutter/cupertino.dart';
import '../../views/shared-widgets/logo-transparent.dart';

class FullLogo extends StatelessWidget{
  final double padding;

  const FullLogo({this.padding = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(this.padding),
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('assets/imgs/home.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: LogoTansparent(),
    );
  }

}