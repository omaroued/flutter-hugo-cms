
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:web/models/article.dart';

class LocalFiles{



  static LocalFiles get instance => LocalFiles();
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }


  Future<File>  _localFile(String name) async {
    final path = await localPath;

    if(! await Directory('$path/posts').exists()){
      await Directory('$path/posts').create(recursive: true);
    }


    return File('$path\\posts\\$name.md');
  }


  Future<File> writeFile(String title,String data) async {
    final file = await _localFile(title);

    // Write the file.
    return file.writeAsString(data,flush: true);
  }


  Future<String> readFile(String path) async {
    try {
      final file = File(path);

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return 'Error';
    }
  }


    Future<List<Article>> getListOfFiles(String dirName) async{
      List<Article> articles=[];

        final path= await localPath + "\\$dirName";




       final directory= Directory(path).list().where((element) =>element.path.substring(element.path.length-3, element.path.length )=='.md').toList();



     await  Future.forEach( await directory,(element) async{




         String content=await readFile(element.path);

         String path=element.path.split("\\").last.replaceFirst('.md','');


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
           fileName: path,
           content: content,

         ));




         // return ;


       });





        return articles;






  }


}
