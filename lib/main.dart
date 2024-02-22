import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 25,left: 6,right: 6,),
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              border: Border.all(width: 2,),
              borderRadius: BorderRadius.circular(12),
             ),
            height: 100,
            //color: Color.fromARGB(255, 248, 245, 237),
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width:2,),
                  borderRadius: BorderRadius.circular(12),),
                  height: 80,
                  width: 90,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(6),
                  child: Row(children: [
                    Expanded(child: Container(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      //color: Colors.amber,
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2,),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    )
                    ),
                    Expanded(child: Container(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      //color: Colors.amber,
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2,),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    )
                    ),
                    Expanded(child: Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    //color: Colors.amber,
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2,),
                      borderRadius: BorderRadius.circular(12),),
                    )) 
                  ],
                  ),
              ) 
            ],
          ),
          ),
          
          
          
          Container(
            
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(2),
            height: 550,
            //color: const Color.fromARGB(255, 229, 229, 226),
            decoration: BoxDecoration(
              border:Border.all(width: 4,) ,
              borderRadius: BorderRadius.circular(12)),
              child: (Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 3),
                      borderRadius: BorderRadius.circular(10,),
                    ),
                    height: 546,
                    width: 120,
                    margin: EdgeInsets.all(5),
                    //color: const Color.fromARGB(255, 59, 89, 141),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 3),
                      borderRadius: BorderRadius.circular(10,),
                    ),
                    height: 546,
                    width: 225,
                    margin: EdgeInsets.only(left: 3,right: 3, top: 3, bottom: 3),

                    //color: const Color.fromARGB(255, 59, 89, 141),
                    child: CustomScrollView(
                      slivers: [
                        SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                          return ListTile(
                            title: Text("Advert $index"),
                            hoverColor: const Color.fromARGB(255, 88, 180, 226),
                          );
                        },
                        childCount: 50,
                        ))
                      ],
                    ),
                  )
                ],
              )),
          ),



          Container(
            padding: EdgeInsets.all(0),
            height: 100,
            //color: Colors.amber[100],
            margin: EdgeInsets.only(bottom: 7),
            //color: const Color.fromARGB(255, 229, 229, 226),
            decoration: BoxDecoration(
              border:Border.all(width: 3,) ,
              borderRadius: BorderRadius.circular(12)),
            child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.kitchen, color: Colors.green[500]),
                        const Text('PREP:'),
                        const Text('25 min'),
                        const Text('35 min'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.timer, color: Colors.green[500]),
                        const Text('COOK:'),
                        const Text('1 hr'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.restaurant, color: Colors.green[500]),
                        const Text('FEEDS:'),
                        const Text('4-6'),
                      ],
                    ),
                  ],
                ),
              ),
          ),
        ],
      )
    );
  }
}