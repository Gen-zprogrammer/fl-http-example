import 'dart:convert';

import 'package:fl_http_example/photo.dart';
import 'package:fl_http_example/photo_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Learn Json Serializable',
      ),
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
  Future<List<Photo>> fetchPhotos(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    return parsePhoto(response.body);
  }

  List<Photo> parsePhoto(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: fetchPhotos(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error has occurred!'),
              );
            } else if (snapshot.hasData) {
              return PhotoList(photos: snapshot.data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add Task'),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Add Task',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Save'),
                      ),
                    ],
                  );
                });
          },
          child: const Icon(
            Icons.note_add,
          ),
        ));
  }
}
