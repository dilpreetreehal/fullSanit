import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sanit/Screens/admin%20screens/approved_user_access.dart';
import 'package:sanit/Screens/admin%20screens/edit_user_profile.dart';
import '../../Model/user_models.dart';

class managerUsers extends StatefulWidget {
  const managerUsers({Key? key}) : super(key: key);
  @override
  _managerUsersState createState() => _managerUsersState();

}

class _managerUsersState extends State<managerUsers> {
  final TextEditingController userEmailController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var userUid;

  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  userModel loggedInUser = userModel();
  userModel editUser = userModel();
  bool _isApproved = false;
  bool _isEditUser = false;

  static const santanderRed=Color(0xffec0000);
  static const santanderDarkRed=Color(0xffcc0000);


  @override
  Widget build(BuildContext context) {



    //IF USER EXISTS ITS VALIDATED AND TRUE
    _validateUser() async {
      setState(() {
      });

      await Future.delayed(Duration(), () {
        setState(() {
          _isApproved = true;
          _isEditUser = true;
        });
      });
    }


    Future checkUser() async {
      //CHECK USER EMAIL EXISTS
      var collection = FirebaseFirestore.instance.collection('users').where('email',isEqualTo: userEmailController.text);
      var querySnapshot = await collection.get();
      //check user even exists
      if(querySnapshot.size==0)
      {
        Fluttertoast.showToast(msg: "User can't be found");
        //removes the widget if the user doesnt exist so they cant accidentally perform an action on a fake user
        setState(() {

          _isApproved = false;
          _isEditUser = false;
        });
        Fluttertoast.showToast(msg: "User does not exist");
      }
      else{
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();

        userUid = data['uid'];
        FirebaseFirestore.instance
            .collection("users")
            .doc(userUid)
            .get()
            .then((value) {
          this.editUser = userModel.fromMap(value.data());
          setState(() {});
        });

        //requires delay in order to have time to fetch the data without issues
        Future.delayed(Duration(milliseconds: 500), () {

          if(editUser.email.toString()!=null){
            _validateUser();

          }

        });
      }

    }
    }

    final userEmailField = TextFormField(
      autofocus: false,
      controller: userEmailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter a valid santander email address");


        }

        return null;
      },
      onSaved: (value) {
        userEmailController.text = value!;
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "User Email",
          hintStyle: TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    final searchButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: santanderRed,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery
              .of(context)
              .size
              .width,
          onPressed: () {
            // saveInfo();
            if (_formKey.currentState!.validate()) {
              checkUser();
            }

          },
          child: const Text("Search",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Manager Users"
          ),
          centerTitle: true,
          backgroundColor: santanderRed,
        ),
        body: SingleChildScrollView(
            child: Container(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //SEARCH BOX FOR USER
                              SizedBox(height: 25),
                              userEmailField,
                              SizedBox(height: 25),
                              searchButton,
                              SizedBox(height:100),
                              //DISPLAY IF USER IS VALID
                              if (_isApproved)
                                Material(
                                  elevation: 5,
                                  // borderRadius: BorderRadius.circular(30),
                                  color: santanderDarkRed,
                                  child: MaterialButton(
                                      padding:EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      minWidth: MediaQuery.of(context).size.width,
                                      onPressed: (){
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (context) => new viewUserApprovedPage(userUid:editUser.uid.toString())));
                                      },
                                      child: const Text("See Access",
                                        textAlign: TextAlign.center,
                                        style :TextStyle(
                                            fontSize: 20, color:Colors.white,fontWeight: FontWeight.bold),
                                      )),
                                ),



                              SizedBox(height:25),
                              //DISPLAYS IF USER IS VALID
                              if (_isEditUser)
                                Material(
                                  elevation: 5,
                                  // borderRadius: BorderRadius.circular(30),
                                  color: santanderDarkRed,
                                  child: MaterialButton(
                                      padding:EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      minWidth: MediaQuery.of(context).size.width,
                                      onPressed: (){
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (context) => new editUserProfile(userUid:editUser.uid.toString())));

                                      },
                                      child: const Text("Edit User",
                                        textAlign: TextAlign.center,
                                        style :TextStyle(
                                            fontSize: 20, color:Colors.white,fontWeight: FontWeight.bold),
                                      )),
                                )
                            ]
                        )
                    )

                )
            )
        )

    );
  }

  }


