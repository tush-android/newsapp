import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutternews/model/news_chhenel_headline_model.dart';
import 'package:flutternews/news_view_model/news_view_model.dart';
import 'package:flutternews/view/category_Screen.dart';
import 'package:flutternews/view/news_detailes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model/category_news.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}
enum filtersitems {bbcNews,independent,cnn,reuters}

class _HomescreenState extends State<Homescreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  filtersitems? selectedvalue;
  final format=DateFormat('dd MMMM yyyy');
  String name='bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen()));
            }, icon: Image.asset('images/category_icon.png',height: height * 0.04,)),
        centerTitle: true,
        title: Text(
          "NEWS",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        /*actions: [
          PopupMenuButton<filtersitems>(initialValue: selectedvalue,icon:Icon(Icons.more_vert_sharp),onSelected: (filtersitems item){
            setState(() {
              selectedvalue = item;
              switch (item) {
                case filtersitems.bbcNews:
                  name = 'bbc-news';
                  break;
                case filtersitems.independent:
                  name = 'independent';
                  break;
                case filtersitems.cnn:
                  name = 'cnn';
                  break;
                case filtersitems.reuters:
                  name = 'reuters';
                  break;
              }
            });
            /*if(filtersitems.bbcNews.name == ite.name){
              name = 'bbc-news';
            }
            if(filtersitems.CNN.name == ite.name){
              name ='ary-news';
            }
            setState(() {
                selectedvalue=ite;
            });*/
            },itemBuilder: (context) => <PopupMenuEntry<filtersitems>>[
            PopupMenuItem<filtersitems>(
              value: filtersitems.bbcNews,
              child: Text('BBC NEWS'),
            ),
            PopupMenuItem<filtersitems>(
              value: filtersitems.cnn,
              child: Text('CNN NEWS'),
            ),
            PopupMenuItem<filtersitems>(
              value: filtersitems.independent,
              child: Text('INDEPENDENT'),
            ),
            PopupMenuItem<filtersitems>(
              value: filtersitems.reuters,
              child: Text('REUTERS'),
            ),
    ]

          ),
        ],*/
        actions: [
          PopupMenuButton<filtersitems>(initialValue:selectedvalue,icon: Icon(Icons.more_vert,color: Colors.black,),
              onSelected: (filtersitems item){
            if(filtersitems.bbcNews.name == item.name){
              name = 'bbc-news';
            }
            if(filtersitems.cnn.name == item.name){
              name='cnn';
            }
            if(filtersitems.independent.name == item.name){
              name='independent';
            }
            setState(() {
              selectedvalue=item; 
            });
              },
              itemBuilder: (BuildContext  context) => <PopupMenuEntry<filtersitems>>[
            PopupMenuItem(
              value:filtersitems.bbcNews,
              child:Text('BBC NEWS')
            ),
            PopupMenuItem(
                value:filtersitems.cnn,
                child:Text('CNN')
            ),
            PopupMenuItem(
                value:filtersitems.independent,
                child:Text('INDEPENDED')
            )
          ])
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * .5,
              width: width,
              child: FutureBuilder<NewsChhnelsHeadlinesModel>(
                future: newsViewModel.fetchnewsChannelHeadLinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: spinKit2);
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Something went wrong!"));
                  } else if (!snapshot.hasData || snapshot.data!.articles == null || snapshot.data!.articles!.isEmpty) {
                    return Center(child: Text("No news available."));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt!);
                        return InkWell(
                          //padding: const EdgeInsets.all(8.0),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailes(
                              newimage: snapshot.data!.articles![index].urlToImage!.toString(),
                              newsDate: snapshot.data!.articles![index].title.toString(),
                              newstitle: snapshot.data!.articles![index].publishedAt.toString(),
                              author: snapshot.data!.articles![index].author.toString(),
                              description: snapshot.data!.articles![index].description.toString(),
                              content: snapshot.data!.articles![index].content!.toString(),
                              source: snapshot.data!.articles![index].source!.name.toString(),
                            )));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height * 0.6,
                                width: width * 0.9,
                                padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => spinKit2,
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    height: height * .22,
                                    width: width * 0.8,
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title ?? '',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index].source!.name ?? '',
                                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<category_news>(
                future: newsViewModel.fetchcategorynewsApi('General'),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: spinKit2);
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Something went wrong!"));
                  } else if (!snapshot.hasData || snapshot.data!.articles == null || snapshot.data!.articles!.isEmpty) {
                    return Center(child: Text("No news available."));
                  } else {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(), // Prevent inner scrolling
                      shrinkWrap: true,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt!);
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailes(
                              newimage: snapshot.data!.articles![index].urlToImage!.toString(),
                              newsDate: snapshot.data!.articles![index].title.toString(),
                              newstitle: snapshot.data!.articles![index].publishedAt.toString(),
                              author: snapshot.data!.articles![index].author.toString(),
                              description: snapshot.data!.articles![index].description.toString(),
                              content: snapshot.data!.articles![index].content!.toString(),
                              source: snapshot.data!.articles![index].source!.name.toString(),
                            )));
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data!.articles![index].urlToImage ?? '',
                                        fit: BoxFit.cover,
                                        height: height * .18,
                                        width: width * .3,
                                        placeholder: (context, url) => Center(child: spinKit2),
                                        errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        height: height * .18,
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index].title ?? '',
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                                            ),
                                            Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child:Text(
                                                    snapshot.data!.articles![index].source!.name ?? '',
                                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                SizedBox(height: 10,),
                                                Text(
                                                  format.format(dateTime),
                                                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );

                          /*Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage ?? '',
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder: (context, url) => Center(child: spinKit2),
                                  errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: height * .18,
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title ?? '',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child:Text(
                                                snapshot.data!.articles![index].source!.name ?? '',
                                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                          ),
                                          SizedBox(height: 10,),
                                          Text(
                                            format.format(dateTime),
                                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );*/
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
