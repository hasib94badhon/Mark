import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:namer_app/widgets/advert_details_popup.dart';

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: FanCarouselImageSlider(
                    sliderHeight: 230,
                    autoPlay: true,
                    imagesLink: images,
                    isAssets: true),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Rafiq Ahmed",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Electrician",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "\$300",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.amber,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
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
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "slkjdfgnpadfadfn odfjaf aspefjigsd eroghasdfv efnvs9dhfv eriughsdfvnadf adfhvjknsefg oidafjvsdfng.",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.call_end_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  AdvertDetailsPopup(),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
