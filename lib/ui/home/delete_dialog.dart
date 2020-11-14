import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:web/models/data_model.dart';
import 'package:web/models/delete_dialog_model.dart';
import 'package:web/widgets/buttons.dart';
import 'package:web/widgets/texts.dart';

class DeleteDialog extends StatelessWidget {
  final DeleteDialogModel model;
  final bool isLocal;
  final String fileName;

  const DeleteDialog(
      {@required this.model, @required this.isLocal, @required this.fileName});

  static Widget create(BuildContext context,{@required bool isLocal, @required String fileName}) {

    final dataModel=Provider.of<DataModel>(context,listen: false);

    return ChangeNotifierProvider<DeleteDialogModel>(
      create: (context) => DeleteDialogModel(
        dataModel: dataModel
      ),
      child: Consumer<DeleteDialogModel>(
        builder: (context, model, _) {
          return DeleteDialog(
            isLocal: isLocal,
            model: model,
            fileName: fileName,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    print(width);
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
          alignment: WrapAlignment.center,
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  'images/delete.svg',
                  width: 300,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Texts.headline3('Are you sure?', Colors.white),
                ),
                (model.isLoading)
                    ? CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.red),
                      )
                    : Wrap(
                        alignment: WrapAlignment.center,
                        children: [


                          Buttons.roundedButton(
                              text: 'Cancel',
                              function: () {
                                Navigator.pop(context);
                              },
                              padding: EdgeInsets.only(
                                  top: 10, left: 20, right: 20, bottom: 10)),








                          Padding(
                            padding: EdgeInsets.only(
                                left: 20,
                                right: (width < 360) ? 20 : 0,
                                top: (width < 360) ? 20 : 0),
                            child: Buttons.defaultButton(
                                text: 'Delete',
                                function: () async {
                                  bool deleteStatus = await ((isLocal)
                                      ? model.deleteLocalArticle(fileName)
                                      : model.deleteArticle(fileName));
                                  Navigator.pop(context, deleteStatus);
                                },
                                color: Colors.red,
                                padding: EdgeInsets.only(
                                    top: 10, left: 20, right: 20, bottom: 10)),
                          )
                        ],
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
