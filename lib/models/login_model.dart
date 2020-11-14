import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'data_model.dart';

class LoginModel with ChangeNotifier{
  bool isLoading=false;

  final DataModel dataModel;

  LoginModel({@required this.dataModel});


  Future<bool> submit(String username,String accessToken,String repoName) async{

    PlatformException error;

    try{
      isLoading=true;
      notifyListeners();

      final request= await http.get("https://api.github.com/repos/$username/$repoName",
          headers: {"Authorization": "token $accessToken"}
      );

      if(request.statusCode==200){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);
        prefs.setString('access_token', accessToken);
        prefs.setString('repo_name', repoName);



        dataModel.username=username;
        dataModel.accessToken=accessToken;
        dataModel.repoName=repoName;

        isLoading=false;
        notifyListeners();

        return true;




      }else{

        print('error');


        error= PlatformException(
          code: request.statusCode.toString(),
          message: json.decode(request.body)['message'],

        );
        throw error;


      }
    }catch(e){
      isLoading=false;
      notifyListeners();


        throw error ?? PlatformException(
          code: '',
          message: 'No internet connection',

        );




    }










  }


}