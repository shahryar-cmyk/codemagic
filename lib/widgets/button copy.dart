import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  AppButton({this.onPressed, this.buttonTitle, this.width});
  final GestureTapCallback onPressed;
  final String buttonTitle;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Container(
        width: width,
        height: 50,
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(124, 116, 146, 0.1),
              blurRadius: 90.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                20.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: RawMaterialButton(
          child: Text(
            buttonTitle,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Colors.white),
          ),
          fillColor: Color.fromRGBO(104, 97, 123, 1),
          splashColor: Color.fromRGBO(124, 116, 146, 1),
          shape: StadiumBorder(),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
