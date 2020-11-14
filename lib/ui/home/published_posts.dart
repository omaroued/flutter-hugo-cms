import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:web/blocs/home_bloc.dart';
import 'package:web/models/article.dart';
import 'package:web/models/published_posts_model.dart';
import 'package:web/ui/editor/editor.dart';
import 'package:web/ui/home/delete_dialog.dart';
import 'package:web/widgets/texts.dart';

class PublishedPosts extends StatelessWidget {

  final PublishedPostsModel model;
  final List<Article> articles;
  final bool isLocal;


  const PublishedPosts({@required this.model,@required this.articles, this.isLocal=false});

  static Widget create({@required List<Article> articles, bool isLocal=false,

  }){
    return ChangeNotifierProvider<PublishedPostsModel>(

        create: (context)=>PublishedPostsModel(),
      child: Consumer<PublishedPostsModel>(
        builder: (context,model,_){

          return PublishedPosts(
            model: model,
            articles:articles,
            isLocal: isLocal,
          );

        },
      ),


    );
  }



  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;



    if(articles.length==0){
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          
          child: SvgPicture.asset('images/empty.svg',
            height: height*0.2,
          ),
        ),
      );
    }else{




      return ListView.builder(
        itemBuilder: (context,position){
          Article article=articles[position];


          return Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(article.title+ position.toString()),



            confirmDismiss: (direction) async{

              bool deleteStatus= false;
            await  showDialog(
              barrierDismissible: false,
                context: context,
                builder: (context)=>DeleteDialog.create(context,isLocal: isLocal,fileName: article.fileName)


              ).then((value) async{

                if(value!=null){

               //   deleteStatus=await ( (isLocal) ? homeBloc.deleteLocalArticle(article.fileName) : homeBloc.deleteArticle(article.fileName));

                  deleteStatus=true;
                }


              });








              return deleteStatus;


            },
            onDismissed: (direction){

              articles.removeAt(position);

              model.updateWidget();



            },

            background: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Padding(
                    padding: EdgeInsets.only(
                        right: 10
                    ),
                    child: Texts.helperText('Delete', Colors.white),
                  ),
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ],
              ),

              color: Colors.red,
            ),

            child: ListTile(

              onTap: (){



                Navigator.push(context, CupertinoPageRoute(
                    builder: (context)=>Editor(
                      article: article,
                    )
                )).then((value){
                  if(value!=null){
                    final homeBloc=Provider.of<HomeBloc>(context,listen: false);


                    if(value=='save'){
                      homeBloc.disableLocalReload=false;
                      homeBloc.updateLocal();
                    }else {
                      homeBloc.disableOnlineReload=false;
                      homeBloc.updateOnline();
                    }

                  }

                });

              },
              title: Texts.headline3(article.title, Colors.white),

              subtitle: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Texts.helperText('Published in: '+article.date, Colors.white),
              ),


              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
            ),
          );
        },
        itemCount: articles.length,

      );

    }

  }
}
