import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:aaram_bd/widgets/CartAppBar.dart';
import 'package:aaram_bd/widgets/CartBottomNavbar.dart';
import 'package:aaram_bd/widgets/CartItemSamples.dart';

class cartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: <Widget>[

          SliverAppBar(
            //pinned: true,
            floating: false,
            expandedHeight: 120,
            flexibleSpace: Container(
              color: Colors.grey,
              child: FlexibleSpaceBar(
                title: Text('AaramBD'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(5),
              child: Center(child: Text('Categories')),
            ),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    //margin: EdgeInsets.only(left: 10,right: 10),
                    decoration: BoxDecoration(
                      color: Colors.green,
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
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(5),
              child: Center(child: Text('Lists')),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                margin: EdgeInsets.only(left: 7, right: 7, top: 5),
                decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                height: 90,
                alignment: Alignment.center,
              );
            },
            childCount: 10,
          )),
        ],
      ),
    );
  }
}
