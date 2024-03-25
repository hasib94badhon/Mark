import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartItemsSamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        for (int i=1; i <5;i++)
        Container(
          height: 80,
          margin:EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(35)
          ),
          child: Row(
            children: [
              Radio(
                value: "", 
                groupValue: "", 
                onChanged: (index){}
                ),
                Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(right: 15),
                  child: Image.asset("images/image$i.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Advertise Title",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 192, 50, 145),

                        ),
                        ),
                        Text("\$55",style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:Color(0xFF4C53A5),

                        ),)
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.end,
                    children: [
                      Row(children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration:BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                              )

                            ]
                          ),

                        )
                      ],)
                    

                  ],),)
            ],
          ),
        )
      ]

    );
  }
}