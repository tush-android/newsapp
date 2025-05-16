import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutternews/model/category_news.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../news_view_model/news_view_model.dart';
import 'news_detailes.dart';
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override

  NewsViewModel newsViewModel = NewsViewModel();
  final format=DateFormat('dd MMMM yyyy');
  String catogoryname='General';
  List<String> btngroups=['General','Entertainment','Health','Sports','Business','Technology'];

  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(scrollDirection:Axis.horizontal,itemCount: btngroups.length,itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    catogoryname=btngroups[index];
                    setState(() {

                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      decoration: BoxDecoration(
                          color: catogoryname == btngroups[index] ?Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(btngroups[index].toString(),style: GoogleFonts.poppins(fontSize: 13,color: Colors.white),),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20,),
            Expanded(child:FutureBuilder<category_news>(
              future: newsViewModel.fetchcategorynewsApi(catogoryname),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Something went wrong!"),
                  );
                }
                else if (!snapshot.hasData || snapshot.data!.articles == null || snapshot.data!.articles!.isEmpty) {
                  return Center(
                    child: Text("No news available."),
                  );
                }
                else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime=DateTime.parse(snapshot.data!.articles![index].publishedAt!.toString());
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
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        height:height * .18,
                                        width:width * .3,
                                        placeholder: (context, url) => Container(
                                          child: Center(
                                            child: SpinKitCircle(
                                              size: 50,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container(
                                      height: height * .18,
                                      padding:EdgeInsets.only(left:15),
                                      child: Column(
                                        children: [
                                          Text(snapshot.data!.articles![index].title.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          maxLines: 3,),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(child: Text(snapshot.data!.articles![index].source!.name.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              ),
                                              Text(format.format(dateTime),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                          /*;*/
                      });
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
