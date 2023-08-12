import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sanit/Model/ticket_models.dart';
import 'package:sanit/Model/user_models.dart';

class approveRequestPage extends StatefulWidget {
  final String id;
  final String requesterUid;

  const approveRequestPage(
      {Key? key, required this.id, required this.requesterUid})
      : super(key: key);

  @override
  _approveRequestPageState createState() => _approveRequestPageState();
}

class _approveRequestPageState extends State<approveRequestPage> {


  //DEFAULT STEP IS IN PROGRESS OR 1
  int currentStep = 1;
  bool isCompleted = false;
  String approved = "Not Set";

  User? user = FirebaseAuth.instance.currentUser;
  ticketModel currentTicket = ticketModel();
  userModel requester= userModel();
  static const santanderRed=Color(0xffec0000);
  static const santanderDarkRed=Color(0xffcc0000);

  void initState() {

    FirebaseFirestore.instance
        .collection('accessTickets')
        .doc(widget.id)
        .get()
        .then((value) {
      this.currentTicket = ticketModel.fromMap(value.data());
      setState(() {});
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.requesterUid)
        .get()
        .then((value) {
      this.requester = userModel.fromMap(value.data());
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Requests",), centerTitle: true,backgroundColor: santanderRed,),
    body: Theme(
    data:ThemeData(

    primarySwatch: Colors.red,
    colorScheme: ColorScheme.light(
    primary: santanderRed
    )
    ),
       child:Stepper(
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: currentStep,
            //IF APPROVED
            onStepContinue: () {
              if (currentStep == 1) {
                setState(() => currentStep += 1);
                approved = "Approved";
                //UPDATE TICKET TO APPROVED
                updateStatus();
              }
            },
            //DENIED TICKET
            onStepCancel: () {
              if (currentStep == 1) {
                setState(() => currentStep += 1);
                approved = "Denied";
                //UPDATE TO DENIED
                updateStatus();
              }
            },
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Container(
                  child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 25),
                            Row(children: <Widget>[
                              if (currentStep == 1) ...[
                                //DISPLAYS TWO BUTTONS ON STEP 1
                                //APPROVE DENY BUTTON
                                SizedBox(
                                  height: 50,
                                  width: 120,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(10),
                                        primary: Colors.white,
                                        backgroundColor: Colors.green),
                                    child: Text('Approve'),
                                    onPressed: details.onStepContinue,
                                  ),
                                ),


                                //DENY BUTTON
                                SizedBox(width: 10,),
                                SizedBox(
                                  height: 50,
                                  width: 120,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(10),
                                        primary: Colors.white,
                                        backgroundColor: santanderRed),
                                    child: Text('Deny'),
                                    onPressed: details.onStepCancel,
                                  ),
                                ),

                              ]
                            ]),
                          ])));
            })));
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text("Request"),
          content: Container(),
        ),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text("In Progress"),
            content: Container(
                child: Column(children: <Widget>[
                  SizedBox(height: 25),
                  Text("Status: ${currentTicket.status}"),
                  Text("Request Type: ${currentTicket.requestType}"),
                  Text("Request Name: ${currentTicket.requestName}"),
                  Text("Account Type: ${currentTicket.accountType}"),
                  Text("Comment: ${currentTicket.comment}"),
                  Text("Requester email: ${requester.email}")
            ]))),
        Step(
            // state: currentStep >2 ? StepState.complete:StepState.indexed,
            isActive: currentStep >= 2,
            title: Text("Approved"),
            content: Container(
              child: Text("This is last step"),
            )),
      ];

  void updateStatus() async {
    //CHANGE STATUS
    String updateStatus =
        currentTicket.toMap().update('status', (value) => approved);
    if (updateStatus != "Not Set") {
      FirebaseFirestore.instance
          .collection('accessTickets')
          .doc(widget.id)
          .update({'status': approved});
    }
  }
}
