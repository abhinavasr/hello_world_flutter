import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  List<ListOfUsers> users = new List<ListOfUsers>();

  MyApp() {
    fetchPost();
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "App From Scratch",
      theme: new ThemeData(primaryColor: Colors.orange),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Sample Hello World Application"),
        ),
        body: new FutureBuilder(
            future: fetchPost(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Waiting to start');
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else {
                    return new ListView.builder(
                      itemBuilder: (BuildContext context, int index) =>
                      new ListDataItem(users[index]),
                      itemCount: users.length,
                    );
                  }
              }
            }
        ),
      ),
    );
  }


  Future fetchPost() async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(
        Uri.parse('http://192.168.86.77:8080'));
    var response = await request.close();
    var responseBody = await response.transform(UTF8.decoder).join();

    final List jsonArray = JSON.decode(responseBody);
    List<ListOfUsers> userLocal = new List<ListOfUsers>();

    print(jsonArray.length);
    for (int iTemp = 0; iTemp < jsonArray.length; iTemp++) {
      var jsonUser = jsonArray[iTemp];
      userLocal.add(new ListOfUsers(
          location: jsonUser['location'],
          name: jsonUser['name'],
          url: jsonUser['url']
      ));
    }
    users.clear();
    users.addAll(userLocal);
    return users;
  }

}

class ListDataItem extends StatelessWidget {
  const ListDataItem(this.listItem);

  final ListOfUsers listItem;

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.all(10.0),
        child: new Card(child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image(image: new NetworkImage(
                listItem.url)),
            new Container(
                padding: const EdgeInsets.all(5.0),
                child: new Text("Name: " + listItem.name,
                    style: new TextStyle(fontWeight: FontWeight.bold))),
            new Container(
                padding: const EdgeInsets.all(5.0),
                child: new Text(
                    "Location: " + listItem.location,
                    style: new TextStyle(color: Colors.grey)))
          ],
        ),)
    );
  }
}

class ListOfUsers {

  final String url;
  final String name;
  final String location;

  ListOfUsers({this.url, this.location, this.name});

}
