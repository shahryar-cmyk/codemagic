import 'package:flutter/material.dart';

Widget textFieldCustom({
  String labelText,
  String hintText,
  TextInputType inputType = TextInputType.text,
  Icon icon,
  bool obscureText = false,
  validator,
  controller,
  Color color,
  bool enabled,
  String value,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xfff0f5fd),
      border: Border.all(width: 1, color: Color(0xfff0f5fd)),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(124, 116, 146, 0.2),
          blurRadius: 10.0, // has the effect of softening the shadow
          spreadRadius: 1.0, // has the effect of extending the shadow
          offset: Offset(
            0.0, // horizontal, move right 10
            10.0, // vertical, move down 10
          ),
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
          hintText: hintText,
          icon: icon,
        ),
        keyboardType: inputType,
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        enabled: enabled,
        initialValue: value,
      ),
    ),
  );
}
