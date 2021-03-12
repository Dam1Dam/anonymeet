import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mmm_anonymeet/Page/Tools/conversationList.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

Future<List<Conversation>> getPeople(String req) async {
  var uri = new Uri.http("10.0.2.2:8080", req);
  var response = await http.get(uri);
  if (response.statusCode == 200) {
    final data = (json.decode(response.body) as List).map((i) =>
        Conversation.fromJson(i)).toList();
    print(data);
    return data;
  }else{
    throw Exception('Failed to load');
  }
}

class Conversation {
  final String pseudo;
  final int id;
  final String title;
  final String genre;
  final String urlIm;

  Conversation({this.pseudo, this.id, this.title, this.genre, this.urlIm});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      pseudo: json['pseudo'],
      id: json['id'],
      title: json['interest_1']+', '+json['interest_2']+', '+json['interest_3'],
      genre: json['gender'],
      urlIm: json['image']
    );
  }
}

class _ChatPageState extends State<ChatPage> {
  Future<List<Conversation>> data;
  void initState() {
    super.initState();
    data = getPeople("/profile/getAll");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: (){
                        //Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back,color: Colors.black,),
                    ),
                    Text("Conversations",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add,color: Colors.pink,size: 20,),
                          SizedBox(width: 2,),
                          Text('Add New',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            FutureBuilder<List<Conversation>>(
              future: data,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ConversationList(
                      name: snapshot.data[index].pseudo,
                      messageText: snapshot.data[index].title,
                      imageUrl: snapshot.data[index].urlIm,
                      time:  snapshot.data[index].genre,
                      isMessageRead: true,
                      id: snapshot.data[index].id
                    );
                  });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              }),
          ],
        ),
      ),
    );
  }
}