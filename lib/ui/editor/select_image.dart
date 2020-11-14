import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web/widgets/buttons.dart';
import 'package:web/widgets/textfields.dart';
import 'package:web/widgets/texts.dart';

class SelectImage extends StatefulWidget {
  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  FocusNode titleFocus = FocusNode();
  FocusNode linkFocus = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF353B43),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        width: 460,
        padding: EdgeInsets.all(20),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: Column(
                children: [
                  SvgPicture.asset('images/image.svg', width: 150),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Texts.subheads('Upload', Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              width: 250,
              margin: EdgeInsets.only(
                  left: (width < 540) ? 0 : 20, top: (width < 540) ? 20 : 0),
              child: Column(
                children: [
                  TextFields.defaultTextField(
                    controller: titleController,
                    focusNode: titleFocus,
                    labelText: 'Title',
                    onSubmitted: (value) {
                      _fieldFocusChange(context, titleFocus, linkFocus);
                    },
                    enabled: true,
                    margin: EdgeInsets.all(0),
                  ),
                  TextFields.defaultTextField(
                    controller: linkController,
                    focusNode: linkFocus,
                    labelText: 'Image link',
                    onSubmitted: (value) {
                      Navigator.pop(context,
                          '![alt ${titleController.text}](${linkController.text})');
                    },
                    enabled: true,
                    margin: EdgeInsets.only(top: 10),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Buttons.defaultButton(
                      text: 'Add Image',
                      function: () {
                        Navigator.pop(context,
                            '![alt ${titleController.text}](${linkController.text})');
                      },
                      padding: EdgeInsets.all(10),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
