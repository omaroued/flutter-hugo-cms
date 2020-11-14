import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:web/models/data_model.dart';
import 'package:web/services/local_files.dart';

class DeleteDialogModel with ChangeNotifier{

  final DataModel dataModel;
  bool isLoading=false;

  final _localFiles=LocalFiles.instance;

  DeleteDialogModel({@required this.dataModel});

  Future<bool> deleteArticle(String fileName)async{




    try{
      isLoading=true;
      notifyListeners();

      final getRequest= await http.get("https://api.github.com/repos/${dataModel.username}/${dataModel.repoName}/contents/content/posts/$fileName.md",
        headers: {"Authorization": "token ${dataModel.accessToken}"},

      );

      String sha=json.decode(getRequest.body)['sha'];

      print(sha);

      print(fileName);







      final deleteRequest= await http.delete("https://api.github.com/repos/${dataModel.username}/${dataModel.repoName}/contents/content/posts/$fileName.md?sha=$sha&&message=${'delete $fileName'}",
        headers: {"Authorization": "token ${dataModel.accessToken}",


        },

      );
      isLoading=false;
      notifyListeners();

      return deleteRequest.statusCode==200;

    }catch(e){

      isLoading=false;
      notifyListeners();

      return false;

    }





  }


  Future<bool> deleteLocalArticle(String fileName)async{


    try{

      isLoading=true;
      notifyListeners();

      final File file=File( (await _localFiles.localPath) + '\\posts\\$fileName.md');


      await file.delete(recursive: true);
      isLoading=false;
      notifyListeners();

      return true;

    }catch(e){
      print(e);

      isLoading=false;
      notifyListeners();

      return false;

    }


  }



}