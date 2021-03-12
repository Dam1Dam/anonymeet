import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class Personne {
  int id;
  String age;
  String email;
  String gender;
  String genderOrientation;
  String imgUrl;
  List<String> interests;
  LatLng position;
  String pseudo;


  Personne({this.id,this.age,this.email
  ,this.gender,this.interests,this.imgUrl,this.position,this.pseudo, String genderOrientation});


  factory Personne.fromJson(Map < String, dynamic > data){
    return Personne(
        id: data['id'],
        age: data['age'],
        genderOrientation: data['gender_orientation'],
        interests: [
          data['interest_1'],
          data['interest_2'],
          data['interest_3'],
          data['interest_3'],
          data['interest_4'],
          data['interest_5']
        ],
        position: LatLng(data['latitude'], data['longitude']),
        gender: data['gender'],
        email: data['email'],
        imgUrl: data['image'],
        pseudo: data['pseudo']
    );
  }

      LatLng getPos() {
        print(position.longitude + position.latitude);
        return position;
      }
      String getPseudo() {
        print(pseudo);
        return pseudo;
      }


}

/*
  Personne(int id, int age, String email, String gender, List<String> interests,
      LatLng position, String pseudo) {
    this.id = id;
    this.age = age;
    this.email = email;
    this.gender = gender;
    this.interests = interests;
    this.position = position;
    this.pseudo = pseudo;
  }
*/

/*
  factory Personne.fromJson(Map<String, dynamic> jSon) {
     json.decode(jSon);

     List<String> interests = [];
     interests.add(json['interest_1']);
     interests.add(json['interest_2']);
     interests.add(json['interest_3']);
     interests.add(json['interest_4']);
     interests.add(json['interest_5']);
     double lat = json['latitude'];
     double long = json['longitude'];
     int id = json['id'];
     int age = json['age'];
     String email = json['email'];
     String gender = json['gender'];
     LatLng pos = LatLng(lat,long);
     String pseudo = json['pseudo'];
     print(id.toString()+age.toString()+email+gender+pseudo);
    return Personne(id,age,email,gender,interests,pos,pseudo);
  }
  */



