import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:web/models/data_model.dart';
import 'package:web/models/submit_dialog_model.dart';
import 'package:web/widgets/buttons.dart';
import 'package:web/widgets/texts.dart';

class SubmitDialog extends StatelessWidget {
  final SubmitDialogModel model;
  final String content;
  final String filePath;


  const SubmitDialog({@required this.model,@required this.content,@required this.filePath});


  static Widget create(BuildContext context,{@required String content,@required String filePath}){

    final dataModel=Provider.of<DataModel>(context,listen: false);

    return ChangeNotifierProvider<SubmitDialogModel>(
        create: (context) => SubmitDialogModel(
          dataModel: dataModel
        ),
      child: Consumer<SubmitDialogModel>(
        builder: (context,model,_){
          return SubmitDialog(
              model:model,
              content: content,
            filePath: filePath,
          );
        },

      ),


    );
  }

  @override
  Widget build(BuildContext context) {

    double width=MediaQuery.of(context).size.width;

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
          children: [
            Container(
              width: 420,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                bottom: 20
              ),
              child: Wrap(
             //   mainAxisAlignment: MainAxisAlignment.center,
             //   crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF242930),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: (model.selectedOption==0) ? Color(0xFF57CC8A): Color(0xFF353B43),
                            width: 2
                        ),
                      ),
                      width: 200,
                      height: 200,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('images/save.svg',
                            width: 130,
                            fit: BoxFit.cover,
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                top: 20
                            ),
                            child: Texts.subheads('Save', Colors.white),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      if(model.selectedOption!=0){
                        model.changeSelectedOption();
                      }
                    },
                  ),

                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF242930),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: (model.selectedOption==1) ? Color(0xFF57CC8A): Color(0xFF353B43),
                            width: 2
                        ),
                      ),
                      width: 200,
                      height: 200,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only( left: width<540 ? 0 : 20, top: width<520 ? 20 : 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('images/upload.svg',
                            width: 130,
                            fit: BoxFit.cover,
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                top: 20
                            ),
                            child: Texts.subheads('Upload', Colors.white),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      if(model.selectedOption!=1){
                        model.changeSelectedOption();
                      }


                    },
                  )






                ],
              ),
            ),


            Align(
              alignment: Alignment.center,
              child:(model.isLoading) ? CircularProgressIndicator(): Wrap(
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
                    padding: EdgeInsets.only(left: 20,right: (width<345)? 20: 0,top: (width<345)? 20: 0,),
                    child: Buttons.defaultButton(text: 'Save',

                        padding: EdgeInsets.only(
                            top: 10,
                            left: 20,
                            right: 20,
                            bottom: 10
                        ), function: ()async{
                      if(model.selectedOption==0){
                        model.save(
                          filePath: filePath,
                          content: content,
                        ).then((value){
                          Navigator.pop(context,'save');

                        });

                      }else{

                        model.upload(filePath: filePath, content: content).then((value){
                          if(value!=null){
                            Navigator.pop(context,'upload');
                          }
                        });




                      }
                    }),



                  ),
                ],

              ),
            )

          ],
        ),
      ),
    );
  }
}
