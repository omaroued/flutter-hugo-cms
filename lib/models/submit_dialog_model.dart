import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:web/models/data_model.dart';
import 'package:web/services/local_files.dart';

class SubmitDialogModel with ChangeNotifier{
  final DataModel dataModel;

  int selectedOption=0;

  bool isLoading=false;

  final LocalFiles localFiles=LocalFiles.instance;

  SubmitDialogModel({@required this.dataModel});


  void changeSelectedOption(){
    selectedOption= 1 - selectedOption;
    notifyListeners();
  }

  void changeLoadingStatus(){
    isLoading= !isLoading;
    notifyListeners();
  }

  Future<String> save({@required String content, @required String filePath}) async{
    isLoading= true;
    notifyListeners();



    final file=  await localFiles.writeFile(filePath, content);




    isLoading= false;
    notifyListeners();
    String path=file.path;







    return path;
  }

  // ignore: missing_return
  Future<String> upload({@required String filePath,@required String content}) async{
    try{
      isLoading= true;
      notifyListeners();


      final getRequest= await http.get("https://api.github.com/repos/${dataModel.username}/${dataModel.repoName}/contents/content/posts/$filePath.md",
        headers: {"Authorization": "token ${dataModel.accessToken}"},

      );

      String sha=json.decode(getRequest.body)['sha'];

      print(sha);



      Codec stringToBase64 = utf8.fuse(base64);


      Map body={
        'content': stringToBase64.encode(content),
        'message': "update",
        'sha':sha,
      };




      final postRequest= await http.put("https://api.github.com/repos/${dataModel.username}/${dataModel.repoName}/contents/content/posts/$filePath.md",
          headers: {"Authorization": "token ${dataModel.accessToken}",

            "Accept": "application/vnd.github.v3+json"
          },
          body:jsonEncode(body)
      );



      print(postRequest.body);


      isLoading= false;
      notifyListeners();



      return postRequest.statusCode.toString();


    }catch(e){

      isLoading= false;
      notifyListeners();
    }




  }







}