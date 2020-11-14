import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/models/data_model.dart';
import 'package:web/ui/splash_screen.dart';

void main(){

  runApp(
      Provider<DataModel>(
        create: (context)=> DataModel(),
        child:  MaterialApp(
          title: 'Hugo/Netlify CMS',
          theme: ThemeData(
            brightness: Brightness.dark,
            backgroundColor:  Color(0xFF242930),
            scaffoldBackgroundColor: Color(0xFF353B43),
            accentColor: Color(0xFF57CC8A),
            primaryColor: Color(0xFF242930),

          ),
          home:SplashScreen.create(),
        ),
      ));
}

