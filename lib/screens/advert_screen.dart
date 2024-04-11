import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:aaram_bd/widgets/advert_details_popup.dart';

class AdvertScreen extends StatelessWidget {
  List<String> images = [
    "images/image1.png",
    "images/image2.png",
    "images/image3.png",
    "images/image4.png",
    "images/image5.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //sliding bar
                SizedBox(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  child: FanCarouselImageSlider(
                      sliderHeight: 200,
                      autoPlay: true,
                      imagesLink: images,
                      isAssets: true),
                ),

                //Basic Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Name,Category,rating star
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Rafiq Ahmed",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w900,
                            fontSize: 23,
                          ),
                        ),
                        Text(
                          "Electrician",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        //This a rating star
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 18,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ),
                      ],
                    ),

                    //Edit profile and show phone
                    Container(
                      //color: Colors.amber,
                      margin: EdgeInsets.only(top: 30, right: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "+01*******33",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 5),

                //Description
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    color: Colors.grey[100],
                    child: Text(
                      "As an electrician, I excel in fixing electrical problems and ensuring safety. I'm skilled in wiring buildings and troubleshooting issues efficiently. My expertise extends to various settings, from homes to commercial spaces. I pride myself on my attention to detail and ability to deliver reliable solutions. Clients trust me to keep their electrical systems running smoothly.",
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 5),

                SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    //margin: EdgeInsets.only(left: 10,right: 10),
                    decoration: BoxDecoration(
                      //color: Colors.green,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                  );
                },
                childCount: 9,
              ),
              gridDelegate:
                  // SliverGridDelegateWithMaxCrossAxisExtent(
                  //   maxCrossAxisExtent: 200,
                  //   mainAxisSpacing: 10,
                  //   crossAxisSpacing: 10,
                  //   childAspectRatio: 4,
                  //   ),
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1.25,

              )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
