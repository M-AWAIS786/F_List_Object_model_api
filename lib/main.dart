import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Model/photomodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter List and Object Api Code'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Photo>> photo;

  @override
  void initState() {
    super.initState();
    photo = fetchPhotos();
  }

  Future<List<Photo>> fetchPhotos() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if (response.statusCode == 200) {
      final parse =
      ((jsonDecode(response.body) as List).cast<Map<String, dynamic>>());
      return parse.map<Photo>((json) => Photo.fromJson(json)).toList();
    } else {
      return throw 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(
              child: Text(
                widget.title,
                style: const TextStyle(color: Colors.white),
              )),
        ),
        body: FutureBuilder(
            future: photo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: ClipRRect(borderRadius: BorderRadius.circular(50.0),child: Image.network(snapshot.data![index].url,)),
                      title:Text.rich(
                          TextSpan(
                              children:[
                                TextSpan(
                                    text: '${snapshot.data![index].id}. ',
                                    style: const TextStyle(fontWeight:FontWeight.w600,
                                        fontFamily:'Roboto',fontSize:20)
                                ),
                                TextSpan(
                                  text: '${snapshot.data![index].title}',
                                ),
                              ]
                          )
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
