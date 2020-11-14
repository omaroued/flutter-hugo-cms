
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:web/models/data_model.dart';
import 'package:web/models/login_model.dart';
import 'package:web/ui/error_dialog.dart';
import 'package:web/ui/home/home.dart';
import 'package:web/widgets/buttons.dart';
import 'package:web/widgets/textfields.dart';

class Login extends StatefulWidget {
  final LoginModel model;

  const Login({@required this.model}) ;


  static Widget create(BuildContext context){
    final dataModel=Provider.of<DataModel>(context,listen: false);

    return ChangeNotifierProvider<LoginModel>(

        create: (context) =>LoginModel(
          dataModel:dataModel,
        ),
      child: Consumer<LoginModel>(
        builder: (context,model,_){
          return Login(
            model:model
          );

        },

      ),


    );

  }




  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  TextEditingController userNameController=TextEditingController(text: '');
  TextEditingController accessTokenController=TextEditingController(text: '');
  TextEditingController repoNameController=TextEditingController(text: '');



  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  FocusNode userNameFocus=FocusNode();
  FocusNode accessTokenFocus=FocusNode();
  FocusNode repoNameFocus=FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }



  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(

      key: _scaffoldKey,

      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [



            Padding(
              padding: EdgeInsets.all(20),
              child: SvgPicture.asset('images/logo.svg',
                height: height*0.5,
              ),
            ),



            Align(
              alignment: Alignment.center,
              child:TextFields.defaultTextField(
                controller: userNameController,
                focusNode: userNameFocus,
                onSubmitted: (value){
                  _fieldFocusChange(context, userNameFocus, accessTokenFocus);
                },
                labelText: 'Username',
                enabled: (widget.model.isLoading)? false: true,
                width: (width>400) ?400  : width,

              ),

            ),

            Align(
              alignment: Alignment.center,

              child: TextFields.defaultTextField(
                obscureText: true,
                margin: EdgeInsets.only(
                    top: 10,
                  left: 20,
                  right: 20
                ),
                  controller: accessTokenController,
                  focusNode: accessTokenFocus,
                  labelText: 'Access token',
                  onSubmitted: (value){
                    _fieldFocusChange(context, accessTokenFocus, repoNameFocus);
                  },
                  enabled: (widget.model.isLoading)? false: true,
                width: (width>400) ?400  : width,
              ),
            ),


            Align(
              alignment: Alignment.center,
              child: TextFields.defaultTextField(
                  margin: EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20
                  ),
                  controller: repoNameController,
                  focusNode: repoNameFocus,
                  labelText: 'Repository name',
                  onSubmitted: (value)async{

                    try{
                      await widget.model.submit(userNameController.text, accessTokenController.text, repoNameController.text);

                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context)=> Home.create(context)
                      ));

                    }catch(e){



                      String message=e.message + ', try again';

                      showDialog(

                          context: context,
                          child:ErrorDialog(message: message)
                      );



                    }





                  },
                  enabled: (widget.model.isLoading)? false: true,
              width: (width>400) ?400  : width),

            ),








            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child:(widget.model.isLoading)? CircularProgressIndicator(): Buttons.defaultButton(text: 'Login',
                    function: ()async{

                      try{
                        await widget.model.submit(userNameController.text, accessTokenController.text, repoNameController.text);

                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context)=> Home.create(context)
                        ));

                      }catch(e){


                        String message=e.message + ', try again';

                        showDialog(

                          context: context,
                          child:ErrorDialog(message: message)
                        );




                      }





                    }),
              ),
            ),
          ],

        ),
      ),

    );
  }


}

