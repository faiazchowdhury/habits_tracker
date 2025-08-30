import 'package:flutter/material.dart';

Textfield(controller, text) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hint: Text(text, style: TextStyle(fontSize: 17)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(width: 2),
      ),
    ),
  );
}
