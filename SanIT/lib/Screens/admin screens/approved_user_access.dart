import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:sanit/Model/ticket_models.dart';
import 'package:sanit/Model/user_models.dart';


class viewUserApprovedPage extends StatefulWidget {
  final String userUid;

  const viewUserApprovedPage({Key? key, required this.userUid}) : super(key: key);

  @override
  _viewUserApprovedPageState createState() => _viewUserApprovedPageState();
}

class _viewUserApprovedPageState extends State<viewUserApprovedPage> {

  User? user = FirebaseAuth.instance.currentUser;
  userModel loggedInUser = userModel();
  ticketModel currentTicket = ticketModel();
  static const santanderRed=Color(0xffec0000);
  static const santanderDarkRed=Color(0xffcc0000);

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = userModel.fromMap(value.data());
      setState(() {});
      print(widget.userUid);
    });

    super.initState();

  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Text("Approved Requests",), centerTitle: true,backgroundColor:santanderRed),

        body:StreamBuilder(
          //only displays tickets waiting for an approval
            stream: FirebaseFirestore.instance.collection('accessTickets').where('status',isEqualTo: 'Approved').where('requesterUid',isEqualTo: widget.userUid).snapshots(),
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
                    child: Material(

                      child: InkWell(
                        onTap: ()  {
                        },

                        child: Container(
                          padding: EdgeInsets.all(12),
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            color:santanderDarkRed,
                            // elevation: 10,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[

                                  //DISPLAY REQUEST DETAILS
                                  Padding(padding: EdgeInsets.all(5)),
                                  Text("REQUEST ID: "+document.id,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                                  Text("Status: "+document['status'],style: TextStyle(fontSize: 16,color: Colors.white),),
                                  Text("Account Type: "+document['accountType'],style: TextStyle(fontSize: 16,color: Colors.white),),
                                  Text("Request Name: "+document['requestName'],style: TextStyle(fontSize: 16,color: Colors.white),),
                                  Text("Comment: "+document['comment'],style: TextStyle(fontSize: 16,color: Colors.white),),
                                ]),
                          ),
                        ),

                      ),
                    ),
                  ));
                }
                ).toList(),
              );
            }
        )
    );

  }
}
