import 'package:flutter/material.dart';
import 'package:web/widgets/texts.dart';

class Buttons{



  static Widget defaultButton({
  @required String text,
    @required Function function,
    Color color= const Color(0xFF57CC8A),
    EdgeInsets padding=const EdgeInsets.all(0),
}){

    return FlatButton(
      padding:(padding==EdgeInsets.all(0))? EdgeInsets.all(20) :EdgeInsets.all(0),
      child: Padding(
        padding: padding,
        child: Texts.subheads(text, Colors.white),
      ),
      onPressed: function,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      color: color,
    );


  }


  static Widget roundedButton({
    @required String text,
    @required Function function,
    Color sideColor= Colors.white,
    EdgeInsets padding=const EdgeInsets.all(0),
  }){

    return FlatButton(
      padding:(padding==EdgeInsets.all(0))? EdgeInsets.all(20) :EdgeInsets.all(0),
      child: Padding(
        padding: padding,
        child: Texts.subheads(text, Colors.white),
      ),
      onPressed: function,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: sideColor, width: 2)
      ),
      color: Colors.transparent,
    );


  }


}