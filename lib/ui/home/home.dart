import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:web/blocs/home_bloc.dart';
import 'package:web/models/article.dart';
import 'package:web/models/data_model.dart';
import 'package:web/ui/editor/editor.dart';
import 'package:web/ui/error_dialog.dart';
import 'package:web/ui/home/published_posts.dart';
import 'package:web/widgets/texts.dart';

class Home extends StatelessWidget {
  final HomeBloc bloc;

   Home({@required this.bloc});

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static Widget create(BuildContext context){

    final dataModel=Provider.of<DataModel>(context,listen: false);

    return Provider<HomeBloc>(
        create:(context) => HomeBloc(dataModel:dataModel),
      child: Consumer<HomeBloc>(
        builder: (context,bloc,_){
          return Home(
              bloc:bloc
          );
        },
      ),


    );
  }

  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;



    return DefaultTabController(

      length: 2,
      child: Scaffold(
        key: _scaffoldKey,

        body: TabBarView(
          children: [

             RefreshIndicator(
            onRefresh: ()async{
              bloc.disableOnlineReload=false;

               bloc.updateOnline();
      },

        child: StreamBuilder(
          stream: bloc.updateOnlineStream.asBroadcastStream(),
          builder: (context,snapshot){
            print('update Online');
            print( bloc.disableOnlineReload);


            return FutureBuilder<List<Article>>(
              future: bloc.getOnlineArticles(bloc.disableOnlineReload,bloc.onlineArticles),
              builder: (context,snapshot){





                if(snapshot.connectionState==ConnectionState.done){

                  if(snapshot.hasError){


    SchedulerBinding.instance.addPostFrameCallback((_) {
      final PlatformException error=snapshot.error;

      showDialog(
          context: context,
          child: ErrorDialog(message: error.message)
      );
    });



                    return SingleChildScrollView(

                      child: Container(
                        height: height-120,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),

                            child: SvgPicture.asset('images/error.svg',
                              height: height*0.2,
                            ),
                          ),
                        ),
                      ),
                      physics: AlwaysScrollableScrollPhysics(),

                    );

                  }else{
                    if(bloc.onlineArticles!=snapshot.data){
                      bloc.onlineArticles=snapshot.data;
                    }


                    if(! bloc.disableOnlineReload){
                      bloc.disableOnlineReload=true;
                    }


                    return PublishedPosts.create(
                      articles: snapshot.data,

                    );
                  }





                }else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );


                }


              },

            );

          },
        ),
      ),


            RefreshIndicator(
        onRefresh: ()async{
          bloc.disableLocalReload=false;

          bloc.updateLocal();
        },
        child: StreamBuilder(
          stream: bloc.updateLocalStream.asBroadcastStream(),

          builder: (context,snapshot){

            print('update local');

            return FutureBuilder<List<Article>>(
              future: bloc.getListOfSavedArticles(bloc.disableLocalReload,bloc.savedArticles),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.done){

                  if(bloc.savedArticles!=snapshot.data){
                    bloc.savedArticles=snapshot.data;
                  }

                  print( bloc.disableLocalReload);

                  if(! bloc.disableLocalReload){
                    bloc.disableLocalReload=true;
                  }








                  return PublishedPosts.create(
                    articles: snapshot.data,
                    isLocal: true
                  );

                }else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );


                }


              },

            );
          },
        ),
      ),








          ],
        ),
        appBar: AppBar(
          title: Texts.headline3('Home', Colors.white),
          centerTitle: true,

          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app,
              color: Colors.white,),
              onPressed: () async{

                await bloc.logOut(context);
              },

            )
          ],

          bottom: TabBar(


            tabs: [
              Tab(
                text: "Published",

              ),
              Tab(
                text: "Saved",
              ),
            ],
          ),
        ),


        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,

          color: Colors.white,

          ),

          onPressed: ()async{






            Navigator.push(context, MaterialPageRoute(
              builder: (context)=>Editor()
            )).then((value){
              if(value!=null){
                if(value=='save'){
                  bloc.disableLocalReload=false;
                  bloc.updateLocal();
                }else{
                  bloc.disableOnlineReload=false;
                  bloc.updateOnline();
                }



              }

            });



          },
        ),
      ),
    );
  }
}
