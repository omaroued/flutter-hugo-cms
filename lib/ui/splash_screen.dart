import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:web/models/data_model.dart';
import 'package:web/models/splash_screen_model.dart';
import 'package:web/ui/home/home.dart';
import 'package:web/ui/login.dart';


class SplashScreen extends StatelessWidget {

  final SplashScreenModel model;

  const SplashScreen({@required this.model});


  static Widget create(){


    return Consumer<DataModel>(
      builder: (context,model,_){

        return ChangeNotifierProvider<SplashScreenModel>(

          create: (context) => SplashScreenModel(
              dataModel: model
          ) ,

          child: Consumer<SplashScreenModel>(
            builder: (context,model,_){
              return SplashScreen(
                  model:model
              );
            },
          ),


        );

      },
    );

  }








  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    return Scaffold(




      body: FutureBuilder<bool>(
        future: model.startupCheck(),
        initialData: false,
        builder: (context,snapshot){



          if(snapshot.connectionState==ConnectionState.done){

            SchedulerBinding.instance.addPostFrameCallback((_) {
              if(snapshot.data==true){
                 Navigator.pushReplacement(context,MaterialPageRoute(
                   builder: (context)=> Home.create(context)
                 ));
              }else{

                Navigator.pushReplacement(context,MaterialPageRoute(
                    builder: (context)=> Login.create(context)
                ));


              }
            });

            return SizedBox();



          }else{

           return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  Padding(
                    padding: EdgeInsets.all(20),
                    child: SvgPicture.asset('images/logo.svg',
                      height: height*0.5,
                    ),
                  ),


                  CircularProgressIndicator(),
                ],
              ),
            );


          }








        },
      ),




    );
  }
}
