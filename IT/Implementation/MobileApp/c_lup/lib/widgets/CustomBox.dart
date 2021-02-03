import 'package:flutter/cupertino.dart';

///Custom SizedBox.
class CustomBox extends StatelessWidget {
  final double width;
  final double height;

  const CustomBox(this.width, this.height, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
