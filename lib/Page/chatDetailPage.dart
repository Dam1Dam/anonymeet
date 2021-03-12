import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mmm_anonymeet/Models/chatMessageModel.dart';


class ChatDetailPage extends StatefulWidget{
  String name;
  String imageUrl;
  int id;
  ChatDetailPage({@required this.name,@required this.imageUrl,@required this.id});
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

Future<List<Message>> getMessage(String req) async {
  var uri = new Uri.http("10.0.2.2:8080", req);
  var response = await http.get(uri);
  if (response.statusCode == 200) {
    final data = (json.decode(response.body) as List).map((i) =>
        Message.fromJson(i)).toList();
    print(data);
    return data;
  }else{
    throw Exception('Failed to load');
  }
}

Future sleep1() {
  return new Future.delayed(const Duration(seconds: 2), () => "2");
}

Future<http.Response> createMessage(String date,String message, int id) {
  return http.post(
    Uri.http('10.0.2.2:8080', '/message/saveMessage'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "message": message,
      "date": date,
      "receiver_id": id,
      "sender_id": 1
    }),
  );
}

class Message {
  final String messageContent;
  final int messageType;

  Message({this.messageContent, this.messageType});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        messageContent: json['message'],
        messageType: json['receiver_id']
    );
  }
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  Future<List<Message>> data;
  void initState() {
    super.initState();
    data = getMessage("/message/findMessageById/1/"+widget.id.toString());
  }
  @override
  TextEditingController message = new TextEditingController();
  List<ChatMessage> messages;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: Colors.black,),
                  ),
                  SizedBox(width: 2,),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 20,
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.name,style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                        SizedBox(height: 6,),
                        Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                      ],
                    ),
                  ),
                  Icon(Icons.settings,color: Colors.black54,),
                ],
              ),
            ),
          ),
        ),
      body: Stack(
        children: <Widget>[
          FutureBuilder<List<Message>>(
            future: data,
            builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10,bottom: 60),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index){
                  return Container(
                    padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                    child: Align(
                      alignment: (snapshot.data[index].messageType == 1?Alignment.topLeft:Alignment.topRight),
                      child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (snapshot.data[index].messageType  == 1?Colors.grey.shade200:Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(snapshot.data[index].messageContent, style: TextStyle(fontSize: 15),),
                    ),
                  ),
                );
                }
              );
              } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      controller: message,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){
                      if(message.value.text.isNotEmpty) {
                        var now = DateTime.now().toString();
                        createMessage(now, message.value.text, widget.id);
                        message.value = new TextEditingValue();
                        data = getMessage("/message/findMessageById/1/"+widget.id.toString());
                        sleep1();
                        setState(() {});
                      }
                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}