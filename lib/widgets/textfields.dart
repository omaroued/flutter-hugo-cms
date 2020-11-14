import 'package:flutter/material.dart';

class TextFields {
  static Widget defaultTextField({
    @required TextEditingController controller,
    @required FocusNode focusNode,
    @required String labelText,
    @required Function(String) onSubmitted,

     Function(String) onChanged,
    @required bool enabled,
    double width=double.infinity,
    String hintText='',
    bool obscureText=false,

    EdgeInsets margin=const EdgeInsets.only(
      left: 20,
      right: 20,
    ),


  }) {
    return Container(
      width: width,
      margin: margin,


      decoration: BoxDecoration(
          color: Color(0xFF242930),
          borderRadius: BorderRadius.all(Radius.circular(15))),

      child: Column(
        children: [
          TextField(
            obscureText: obscureText,
            onChanged: (onChanged==null)? (value){} : onChanged,
            enabled: enabled,
            controller: controller,
            focusNode: focusNode,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 11, bottom: 5, top: 5, right: 11),
                labelText: labelText,
            hintText: hintText),
          )
        ],
      ),
    );
  }




  static Widget expandedTextField({
    @required TextEditingController controller,
    @required FocusNode focusNode,
    @required Function(String) onSubmitted,
    Function(String) onChanged,
    @required bool enabled,
    String hintText='',
    EdgeInsets margin=const EdgeInsets.only(
      left: 20,
      right: 20,
    ),


  }){

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFF242930),
            borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        margin: margin,
        child: TextField(
          enabled: enabled,
          maxLines: null,
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.multiline,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration:  InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
            EdgeInsets.only(left: 11, bottom: 5, top: 5, right: 11),
            hintText: hintText,
          ),
        ),
      ),
    );


  }
}
