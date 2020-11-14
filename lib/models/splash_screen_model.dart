import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web/models/data_model.dart';
import 'package:web/services/local_files.dart';

class SplashScreenModel with ChangeNotifier{
  final DataModel dataModel;

  SplashScreenModel({@required this.dataModel});



  Future<bool> startupCheck() async {

    await Future.delayed(Duration(seconds: 1));


    LocalFiles localFiles=LocalFiles();
    final directory= Directory( await localFiles.localPath +'\\posts');
    if(! await directory.exists()){
     await directory.create();


     print(directory.path);
    }



    SharedPreferences prefs = await SharedPreferences.getInstance();


    List<String> listOfImages=[
       "images/save.svg",
      "images/upload.svg",
      "images/empty.svg",
      "images/error.svg",
     "images/logo.svg"
    ];

    await Future.forEach(listOfImages, (image)async{

      await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, image), null);

    });









    if( prefs.containsKey('username') &&  prefs.containsKey('access_token') && prefs.containsKey('repo_name')){

      final String username=prefs.getString('username');
      final String accessToken=prefs.getString('access_token');
      final String repoName=prefs.getString('repo_name');


      final request= await http.get("https://api.github.com/repos/$username/$repoName",
          headers: {"Authorization": "token $accessToken"}
      );

      if(request.statusCode==200){


        dataModel.username=username;
        dataModel.accessToken=accessToken;
        dataModel.repoName=repoName;


        return true;

      }else{
        return false;

      }








    }else{


      return false;
    }




  }






}