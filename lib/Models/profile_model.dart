class Profile{
  String name;
  String email;
  String imageUrl;
  String uid;
  String sex;
  DateTime birthDate;



  Profile(String email, String uid, String name, String url){
    this.name = name;
    this.email = email;
    this.uid = uid;
    this.imageUrl = url;
  }



}