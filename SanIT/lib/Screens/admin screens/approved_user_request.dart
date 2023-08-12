import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sanit/Model/ticket_models.dart';
import 'package:sanit/Model/user_models.dart';
import 'package:sanit/Screens/admin%20screens/request_approve_screen.dart';

class viewUserRequestsPage extends StatefulWidget {
  const viewUserRequestsPage({Key? key}) : super(key: key);

  @override
  _viewUserRequestsPageState createState() => _viewUserRequestsPageState();
}

class _viewUserRequestsPageState extends State<viewUserRequestsPage> {

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
    });

      super.initState();
  }




  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(
          title: Text("Requests",), centerTitle: true,backgroundColor:santanderRed),

        body:StreamBuilder(
            //only displays tickets waiting for an approval or status update
            stream: FirebaseFirestore.instance.collection('accessTickets').where('status',isEqualTo: 'In Progress').snapshots(),
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
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => approveRequestPage(id:document.id, requesterUid:document["requesterUid"])));
                          setState(() {
                          });
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
                                  Padding(padding: EdgeInsets.all(5)),
                                  //DIPLAYS INFO
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
                  );
                }
                ).toList(),
              );
            }
        )
    );

  }
}
