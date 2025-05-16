import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
class NewsDetailes extends StatefulWidget {
  final String newimage,newstitle,newsDate,author,description,content,source;
  const NewsDetailes({Key? key,required this.newimage,
    required this.newstitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source}):super(key: key);

  @override
  State<NewsDetailes> createState() => _NewsDetailesState();
}

class _NewsDetailesState extends State<NewsDetailes> {
  final format=DateFormat('dd MMMM yyyy');
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    DateTime dateTime=DateTime.parse(widget.newstitle);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
         Container(
           child: Container(
             height:  height * .45,
             child: ClipRRect(
               borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
               topRight: Radius.circular(40),
               ),
               child: CachedNetworkImage(imageUrl: widget.newimage,fit: BoxFit.cover,
               placeholder: (context,u) => Center(child: CircularProgressIndicator( ),)),
             ),
           ),
         ),
          Container(
            height:  height * .6,
            margin: EdgeInsets.only(top:height * .4),
            padding: EdgeInsets.only(top: 20,right: 20,left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40),
              ),
            ),
            child: ListView(
              children: [
                Text(widget.newsDate,style: GoogleFonts.poppins(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w700),),
                SizedBox(height: height * 0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.source,style: GoogleFonts.poppins(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w700)),
                    Text(format.format(dateTime),style: GoogleFonts.poppins(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: height * 0.02,),
                Text(widget.description,style: GoogleFonts.poppins(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
