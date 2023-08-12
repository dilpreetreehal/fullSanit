import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sanit/Model/ticket_models.dart';
import 'package:sanit/Model/user_models.dart';
import 'package:sanit/Screens/user%20screens/requests_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class makeRequestPage extends StatefulWidget {
  const makeRequestPage({Key? key}) : super(key: key);

  @override
  _makeRequestPageState createState() => _makeRequestPageState();
}

class _makeRequestPageState extends State<makeRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController requestNameController =
  new TextEditingController();
  final TextEditingController commentController = new TextEditingController();

  //SET STEPPER TO 0 TO BEGIN
  int currentStep = 0;
  bool isCompleted = false;
  final auth = FirebaseAuth.instance;

  User? user = FirebaseAuth.instance.currentUser;
  userModel loggedInUser = userModel();
  ticketModel currentTicket = ticketModel();

  //SET DEFAULT VALUES
  String requestTypeDropDown = 'Database';
  bool _typeSelected = false;
  String accountTypeDropDown ="Pre-Production";


  var approvedColor,deniedColor;

  static const santanderRed=Color(0xffec0000);
  static const santanderDarkRed=Color(0xffcc0000);


  //COLOUR BLIND CHECK
  Future checkColorBlind() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool('colourBlind');
    if (boolValue==true){
      approvedColor=Colors.blue[800];
      deniedColor=Colors.orange;
    }
    else if (boolValue==false){
      approvedColor=Colors.green;
      deniedColor=santanderDarkRed;
    }

  }

  _validateUser() async {
    setState(() {
    });
    await Future.delayed(Duration(), () {
      setState(() {
        _typeSelected=true;
      });
    });
  }


  void initState() {
    //GET LOGGED IN USER
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = userModel.fromMap(value.data());
      setState(() {});
      checkColorBlind();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Make Requests",
          ),
          backgroundColor: santanderRed,
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => requestPage()));
              },
              child: Text("View Requests"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        // body: SingleChildScrollView(

        body: Theme(
            //COLOUR THEME
            data:ThemeData(

                primarySwatch: Colors.red,
                colorScheme: ColorScheme.light(
                    primary: santanderRed
                )
            ),

            child:Stepper(
                //HORIZONTAL AT THE TOP OF PAGE
                type: StepperType.horizontal,
                steps: getSteps(),

                currentStep: currentStep,
                //BUTTON PRESSED
                onStepContinue: () {
                  if (currentStep == 0 && _formKey.currentState!.validate()) {
                    setState(() => currentStep += 1);
                    setState(() => isCompleted = true);
                    //UPLOADS TICKET ON SUBMIT
                    uploadTicket();
                  }
                },
                //CLEARS THE TICKET IF STATE REACHED
                onStepCancel: (){
                  setState(() {
                    //DEFAULTS DETAILS
                    _typeSelected=false;
                    requestTypeDropDown = 'Database';
                  });
                  //CLEARS BOXES
                  commentController.clear();
                  requestNameController.clear();
                },
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Container(
                      child: Padding(
                          padding: const EdgeInsets.all(36.0),

                          child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 25),
                                Row(
                                    children: <Widget>[
                                      //WHEN ON PAGE 1 OF STEPPER
                                      if (currentStep == 0)...[
                                        SizedBox(
                                            height: 50,
                                            width: 120,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  padding: EdgeInsets.all(10),
                                                  primary: Colors.white,
                                                  backgroundColor: approvedColor),
                                              child: Text('SUBMIT'),
                                              onPressed: details.onStepContinue,
                                            )),
                                        SizedBox(width: 10,),
                                        SizedBox(
                                          height: 50,
                                          width: 120,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(10),
                                                primary: Colors.white,
                                                backgroundColor: deniedColor),
                                            child: Text('CLEAR'),
                                            onPressed: details.onStepCancel,
                                          ),
                                        ),
                                      ]

                                    ]),

                              ])));
                }))
    );
  }

  List<Step> getSteps() => [

    Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        //FIRST PAGE FORM TO FILL OUT
        title: Text("Request"),
        content: Container(
            child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        children: <Widget>[
                          SizedBox(height: 25),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: santanderRed, borderRadius: BorderRadius.circular(10)),

                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Request Type:  ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                                    // dropdown below..
                                    DropdownButton<String>(
                                      dropdownColor: Colors.grey,
                                      value: requestTypeDropDown,
                                      onChanged: (String? newValue) {
                                        _validateUser();
                                        setState(() =>
                                        requestTypeDropDown = newValue!,
                                        );
                                      },
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      //LIST FOR DROP DOWN
                                      items:<String>['Database', 'Server','Application','Software','Hardware']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) => DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          ))
                                          .toList(),

                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 42,
                                      underline: SizedBox(),
                                    ),

                                  ])
                          ),
                          //GAP
                          SizedBox(height: 25),
                          //ONLY SHOWS IF TYPE HAS BEEN SELECTED
                          if (_typeSelected)
                            TextFormField(
                              autofocus: false,
                              controller: requestNameController,
                              // keyboardType: TextInputType.,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("You must specify the request name");
                                }
                                return null;
                              },
                              onSaved: (value) {
                                requestNameController.text = value!;
                              },
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.comment),
                                  contentPadding:
                                  EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: ("Name of "+requestTypeDropDown),
                                  hintStyle: TextStyle(color: Colors.blueGrey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),

                          SizedBox(height: 25),
                          //ONLY SHOWS IF TYPE HAS BEEN SELECTED
                          if (_typeSelected)
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: santanderRed, borderRadius: BorderRadius.circular(10)),

                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Account Type:  ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                                      // dropdown below..
                                      DropdownButton<String>(
                                        dropdownColor: Colors.grey,
                                        value: accountTypeDropDown,
                                        onChanged: (String? newValue) {
                                          _validateUser();
                                          setState(() =>
                                          accountTypeDropDown = newValue!,
                                          );
                                        },
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        //DROP DOWN VALUES
                                        items:<String>['Pre-Production', 'Development','Simulation','Production','Not Applicable']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) => DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),

                                            ))
                                            .toList(),

                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 42,
                                        underline: SizedBox(),
                                      ),

                                    ])
                            ),
                          SizedBox(height: 25),

                          //ADDITIONAL COMMENT BOX
                          TextFormField(
                            autofocus: false,
                            controller: commentController,
                            // keyboardType: TextInputType.,
                            validator: (value) {
                              if (value!.isEmpty) {
                              }
                              return null;
                            },
                            onSaved: (value) {
                              commentController.text = value!;
                            },
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            //next button on keyboard
                            textInputAction: TextInputAction.next,
                            minLines: 2,
                            maxLines: 4,
                            decoration: InputDecoration(
                                //icon for box
                                prefixIcon: Icon(Icons.comment),
                                contentPadding:
                                EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Comment",
                                hintStyle: TextStyle(color: Colors.blueGrey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          )
                        ]))))),

    //IN PROGRESS STEP WHERE IT END FOR USER
    Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,

        title: Text("In Progress"),
        content: Container(
            child: Column(children: <Widget>[

              Card(
                  margin: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  child: Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                          children: [
                            Expanded(flex: 2, child: Icon(Icons.request_page)),
                            Expanded(
                              flex: 8,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Request Type: " +requestTypeDropDown),
                                    Text("Name: " + requestNameController.text),
                                    Text("Account Type: " + accountTypeDropDown),
                                    Text("Comment" + commentController.text),
                                  ],
                                ),
                              ),
                            )
                          ])
                  )
              ),


            ]))),
  ];


  //UPLOAD TICKET WITH INFORMATION FROM FORM
  Future<void> uploadTicket() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    //MAPS TO TICKET MODEL 
    ticketModel ticketModels = ticketModel();
    // send values
    ticketModels.requestType = requestTypeDropDown;
    ticketModels.comment = commentController.text;
    //TICKETS WILL ALWAYS BE IN PROGRESS WHEN MADE
    ticketModels.status = "In Progress";
    ticketModels.requesterUid = user!.uid;
    ticketModels.accountType = accountTypeDropDown;
    ticketModels.requestName = requestNameController.text;

    //UPLOAD MAPPED MODEL
    await firebaseFirestore
        .collection('accessTickets')
        .doc()
        .set(ticketModels.toMap());
  }
//
// void checkForm(){
//   if (_formKey.currentState!.validate()){
//     // details.onStepContinue;
//   }
// }

}
