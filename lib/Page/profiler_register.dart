import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/rendering.dart';
import 'package:mmm_anonymeet/Models/interest_model.dart';
import 'package:mmm_anonymeet/Page/Tools/toast_utils.dart';
import 'package:mmm_anonymeet/Services/interest_api.dart';

class ProfilerRegister extends StatefulWidget {
@override
_ProfilerRegisterState createState() => _ProfilerRegisterState();
}


  class _ProfilerRegisterState extends State<ProfilerRegister> {

  List<String> tags = [];
  List<Interest> options;
  List<String> interestsString = List<String>();
  List<String> genders = ["Boy", "Girl"];
  DateTime selectedDate = DateTime.now();
  String pseudo = '';
  String gender = '';
  String genderChoice='';


  @override
  void initState(){
    super.initState();
    fetchInterestToList();

  }

  void fetchInterestToList() async{
    options = await fetchInterests();

    for (Interest interest in options ){
      interestsString.add(interest.name);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child:  Column(
          children: <Widget>[
            sizedBox(),
            textPseudo(),
            sizedBox(),
            dateText(),
            sizedBox(),
            datePicker(),
            sizedBox(),
            Text(
              'Choose your gender',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            genderChipChoice(),
            sizedBox(),
            Text(
              'Select gender you are interested in',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            genderInterestChipChoice(),
            sizedBox(),
            interestChoice(),
            sizedBox(),
            saveButton(),


          ],
        ),
      ),

    );
  }


  Widget interestChoice(){
    return ChipsChoice<String>.multiple(
        value: tags,
        onChanged: (val) => setState(() {
          if (val.length >5){
            ToastUtil.show(
                ToastDecorator(
                  widget: Text(
                      "Vous ne pouvez choisir que 5 centres d'intérêts \n (ps: ça risque d'être compliqué de trouver l'âme soeur sinon!)",
                      style: TextStyle(color: Colors.white)
                  ),
                  backgroundColor: Colors.red,
                ),
                context,
                gravity: ToastGravity.top);
          }else{
            tags = val;
          }
        }),
        choiceItems: C2Choice.listFrom<String, String>(
          source: interestsString,
          value: (i, v) => v,
          label: (i, v) => v,
          tooltip: (i, v) => v,

        )
    );

  }

  Widget genderChipChoice(){
    return ChipsChoice<String>.single(
        value: gender,
        onChanged: (val) => setState(() {
            gender = val;
        }),
        choiceItems: C2Choice.listFrom<String, String>(
          source: genders,
          value: (i, v) => v,
          label: (i, v) => v,
          tooltip: (i, v) => v,

        )
    );

  }
  Widget genderInterestChipChoice(){
    return ChipsChoice<String>.single(
        value: genderChoice,
        onChanged: (val) => setState(() {
          genderChoice = val;
        }),
        choiceItems: C2Choice.listFrom<String, String>(
          source: genders,
          value: (i, v) => v,
          label: (i, v) => v,
          tooltip: (i, v) => v,

        )
    );

  }

  Widget dateText(){
    return Text(
      "${selectedDate.toLocal()}".split(' ')[0],
      style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
    );
  }

  Widget datePicker(){
   return ElevatedButton(
      onPressed: () => _selectDate(context), // Refer step 3
      child: Text(
        'Select date',
        style:
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget sizedBox(){
    return SizedBox(
      height: 20.0,
    );
  }
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.toLocal(), // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget textPseudo(){
    return TextField(
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
      maxLines: 1,
      onSubmitted: (String text) {
        // on submitted ie when submit
        setState(() {
          pseudo = text;
        });
      },
      decoration: new InputDecoration(
          hintText: "", labelText: "Modify Pseudo"),
    );
  }

  Widget saveButton(){
    return ElevatedButton(
      onPressed: () {

      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Save',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey
      ),



    );

  }


}