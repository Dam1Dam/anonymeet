
import 'dart:convert';

List<Interest> interestFromJson(String str) => List<Interest>.from(json.decode(str).map((x) => Interest.fromJson(x)));

String interestToJson(List<Interest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Interest {
  Interest({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}