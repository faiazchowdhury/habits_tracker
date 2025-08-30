import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class ErrorText extends StatelessWidget {
  String error;
  ErrorText(this.error);
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: error != "",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 0,
            child: Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(error,
                softWrap: true,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
