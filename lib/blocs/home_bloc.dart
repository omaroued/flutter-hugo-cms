import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web/models/article.dart';
import 'package:web/models/data_model.dart';
import 'package:web/services/local_files.dart';
import 'package:http/http.dart' as http;
import 'package:web/ui/login.dart';

class HomeBloc {
  final DataModel dataModel;


  List<Article> onlineArticles=[];
  List<Article> savedArticles=[];

  bool disableOnlineReload=false;
  bool disableLocalReload=false;









  final StreamController<bool> _updateLocalController = StreamController<bool>.broadcast();

  HomeBloc({@required this.dataModel});
  Stream<bool> get updateLocalStream => _updateLocalController.stream;


  final StreamController<bool> _updateOnlineController = StreamController<bool>.broadcast();
  Stream<bool> get updateOnlineStream => _updateOnlineController.stream;



  void updateLocal() => _updateLocalController.add(true);

  void updateOnline() => _updateOnlineController.add(true);



  void dispose() {
    _updateLocalController.close();
    _updateOnlineController.close();
  }



  final _localFiles=LocalFiles.instance;



  Future<List<Article>> getListOfSavedArticles(bool disableReload, List<Article> savedArticles) async =>(disableReload) ? savedArticles : _localFiles.getListOfFiles('posts');


  // ignore: missing_return
  Future<List<Article>> getOnlineArticles(bool disableReload, List<Article> savedArticles) async{

    if(disableReload){

      return savedArticles;


    }else{


      PlatformException error;

      try{

        final request= await http.get("https://api.github.com/repos/${dataModel.username}/${dataModel.repoName}/contents/content/posts",
            headers: {"Authorization": "token ${dataModel.accessToken}"}
        );
        if(request.statusCode!=200){

          error=PlatformException(
            code: request.statusCode.toString(),
            message: json.decode(request.body)['message']
          );


        }else{
          final List result= await json.decode(request.body);

          List<Article> articles=[];


          await Future.forEach(result,(element) async{
            String content=await http.read(element['download_url']);


            String fileName=element['name'].toString().replaceAll('.md', '');

            String config=content.substring(content.indexOf("+++"),content.indexOf('+++',3)+3)
                .replaceAll('+++\n', '').replaceAll('+++', '').replaceAll('=', ':')
                .replaceAll('title', '\"title\"')
                .replaceAll('tags', ',\"tags\"')
                .replaceAll('date', ',\"date\"');
            config='{' +config + '}';

            content= content.substring(content.indexOf('+++',4)+4);
            Map jsonConfig = await json.decode(config);

            articles.add(Article(title: jsonConfig['title'],
              tags: jsonConfig['tags'],
              date: jsonConfig['date'],
              fileName: fileName,
              content: content,

            ));





          });

          return articles;

        }





      }catch (e){

        throw error ?? PlatformException(
          code: '',
          message: 'No internet connection',

        );

      }










    }





  }




  Future  logOut(BuildContext context)async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('username');
    prefs.remove('access_token');
    prefs.remove('repo_name');

    dataModel.username=null;
    dataModel.accessToken=null;
    dataModel.repoName=null;

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context)=> Login.create(context)
    ));



  }





}