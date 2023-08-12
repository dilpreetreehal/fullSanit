import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sanit/Model/ticket_models.dart';
import 'package:sanit/Model/user_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'makeRequest_screen.dart';


class requestPage extends StatefulWidget {
  const requestPage({Key? key}) : super(key: key);

  @override
  _requestPageState createState() => _requestPageState();
}

class _requestPageState extends State<requestPage> {

  User? user = FirebaseAuth.instance.currentUser;
  userModel loggedInUser = userModel();
  ticketModel currentTicket = ticketModel();
  var approvedColor,deniedColor;
  static const santanderRed=Color(0xffec0000);
  static const santanderDarkRed=Color(0xffcc0000);

  //CHECK IF USER SHARED PREF IS COLOUR BLIND
  Future checkColorBlind() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool('colourBlind');

    if (boolValue==true){
      approvedColor=Colors.blue[800];
      deniedColor=Colors.orange[800];
    }
    else if (boolValue==false){
      approvedColor=Colors.green;
      deniedColor=santanderDarkRed;
    }
  }


  @override
  void initState() {
    //SET LOGGED IN USER
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = userModel.fromMap(value.data());
      setState(() {});
      checkColorBlind();
    });

    //GET TICKET INFORMATION
    FirebaseFirestore.instance
        .collection('/users/'+user!.uid+'/tickets')
        .doc()
        .get()
        .then((value) {
      this.currentTicket = ticketModel.fromMap(value.data());

      // .set({'Issue':"Tester"});
      super.initState();
    });
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Requests",), backgroundColor: santanderRed,
        actions: <Widget>[
      FlatButton(
      textColor: Colors.white,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => makeRequestPage()));
        },
        //NEW REQUEST BUTTON
        child: Text("New Request +"),
        shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
      ),
    ]

      ),

      //GETS ALL TICKETS INTO STREAM =LOOPS THROUGH ALL
      body:StreamBuilder(
        //ONLY GETS LOGGED IN USER TICKETS
        stream: FirebaseFirestore.instance.collection('accessTickets').where('requesterUid',isEqualTo: user!.uid).snapshots(),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
        {

          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          SizedBox(height: 20);
          return ListView(
            children: snapshot.data!.docs.map((document)
            {
              return Center(
                child: Material(

                  child: InkWell(
                    onTap: ()  {
                      setState(() {
                      });
                    },

                    child: Container(
                      padding: EdgeInsets.all(12),
                      width: MediaQuery.of(context).size.width,
                      //CREATE CARD WITH INFORMATION
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Colors.grey[900],
                        // elevation: 10,
                        child: Column(
                          textDirection:TextDirection.ltr,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[

                            Padding(padding: EdgeInsets.all(5)),
                            //GETS TICKET INFORMATION AND DISPLAYS IT
                            Text("REQUEST ID: "+document.id,style: TextStyle(fontSize: 16,color: Colors.white),),
                            if(document['status']=="Approved")
                              //GETS COLOUR DEPENENDING IF USER IS COLOUR BLIND
                              Text("Status: "+document['status'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:approvedColor),),
                            if(document['status']=="In Progress")
                              Text("Status: "+document['status'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.amberAccent),),
                            if(document['status']=="Denied")
                              Text("Status: "+document['status'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: deniedColor),),
                            Text("Request Type: "+document['requestType'],style: TextStyle(fontSize: 16,color: Colors.white),),
                            Text("Request Name: "+document['requestName'],style: TextStyle(fontSize: 16,color: Colors.white),),
                            Text("Account Type: "+document['accountType'],style: TextStyle(fontSize: 16,color: Colors.white),),
                            Text("Comment: "+document['comment'],style: TextStyle(fontSize: 16,color: Colors.white),),
                        ]),
                        ),
                      ),
                    ),
                  )
              );


            }
            ).toList(),

          );

        }

      )


    );


    }
  }
