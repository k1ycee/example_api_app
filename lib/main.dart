import 'package:example_app/api/api_call.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/news_model.dart';

void main() {
  runApp(News());
}

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final news = ApiCallClass().getNews();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Article>>(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.data.toString()));
        }
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    snapshot.data[index].urlToImage == null
                        ? ""
                        : snapshot.data[index].urlToImage),
              ),
              title: Text(snapshot.data[index].title == null
                  ? ""
                  : snapshot.data[index].title),
              subtitle: Text(snapshot.data[index].author == null
                  ? ""
                  : snapshot.data[index].author),
              trailing: IconButton(
                icon: Icon(Icons.launch),
                onPressed: () async {
                  await canLaunch(snapshot.data[index].url)
                      ? launch(snapshot.data[index].url)
                      : throw "Can't launch ${snapshot.data[index].url}";
                },
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      future: news,
    ));
  }
}



