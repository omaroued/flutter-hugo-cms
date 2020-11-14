import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web/widgets/buttons.dart';
import 'package:web/widgets/texts.dart';


class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({@required this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(

      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF353B43),
          borderRadius: BorderRadius.all(Radius.circular(10)),

        ),
        width: 460,
        // height: 100,
        padding: EdgeInsets.all(20),
        child: Wrap(
          alignment: WrapAlignment.center,

          children: [

            Column(
              children: [

                SvgPicture.asset(
                  'images/error.svg',
                  width: 300,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Texts.headline3(message, Colors.white,TextAlign.center),
                ),


                Padding(
                  padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                  ),
                  child: Buttons.defaultButton(
                      text: 'Ok',
                      function: () async {
                        Navigator.pop(context);
                      },
                      color: Colors.red,
                      padding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10)),
                )


              ],

            )

          ],
        ),
      ),
    );
  }
}
