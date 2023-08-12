import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sanit/Model/user_models.dart';
import 'package:sanit/Screens/admin%20screens/manage_user_screen.dart';


class editUserProfile extends StatefulWidget {
  final String userUid;
  const editUserProfile({Key? key,  required this.userUid}) : super(key: key);

  @override
  _editUserProfileState createState() => _editUserProfileState();
}



class _editUserProfileState extends State<editUserProfile> {


  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  User? user = FirebaseAuth.instance.currentUser;
  userModel editUser = userModel();


  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmPasswordController = new TextEditingController();

  static const santanderRed=Color(0xffec0000);
  static const santanderDarkRed=Color(0xffcc0000);

  String dropdownValue = 'No';



  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userUid)
        .get()
        .then((value) {
      this.editUser= userModel.fromMap(value.data());
      setState((){
      });
    });

    super.initState();
  }




  @override
  Widget build(BuildContext context) {


    //FIRST NAME FIELD
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isNotEmpty) {
          // return("enter");
        }
        //Value can be empty but not less than 3 as they may not want to change their name
        if (!regex.hasMatch(value) && value.isNotEmpty) {
          return ("Enter Valid First Name(Min. 3 Character)");
        }
        return null;
      },


      onSaved: (value) {
        firstNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      style:TextStyle(color: Colors. black),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "${editUser.firstName}",
          hintStyle:TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),

    );
    //LAST NAME FIELD

    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isNotEmpty) {
          // return("enter");
        }
        //Value can be empty but not less than 3 as they may not want to change their name
        if (!regex.hasMatch(value) && value.isNotEmpty) {
          return ("Enter Valid Last Name(Min. 3 Character)");
        }
        return null;
      },


      onSaved: (value) {
        lastNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      style:TextStyle(color: Colors. black),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_box),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "${editUser.lastName}",
          hintStyle:TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),

    );

    //EMAIL FIELD
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        //ONLY ENTER VALID SANTANDER EMAIL
        if (value!.isEmpty)
        {

        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@santander.com").hasMatch(value) && value.isNotEmpty)
        {
          return ("Please enter a valid santander email address "'\n'
              "e.g. JohnDoe@santander.com");
        }
        return null;
      },

      onSaved: (value) {
        emailController.text = value!;
      },
      style:TextStyle(color: Colors. black),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "${editUser.email}",
          hintStyle:TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),

    );

    //UPDATE PASSWORD

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {

        }
        if (!regex.hasMatch(value) && value.isNotEmpty) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      style:TextStyle(color: Colors. black),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "New Password",
          hintStyle:TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),

    );

    //CONFIRM PASSWORD
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if  (confirmPasswordController.text != passwordController.text){
          return ("Passwords do not match");
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      style:TextStyle(color: Colors. black),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          hintStyle:TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),

    );

    final adminDropDown=DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        alignment: Alignment.center,
        color: santanderDarkRed,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          // print(dropdownValue);
        });
      },

      //ARE THEY ADMIN OPTIONS
      items: <String>['No', 'Yes',]
          .map<DropdownMenuItem<String>>((String value) {


        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),

        );

      }).toList(),
    );


    final saveButton = Material(
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
            if (_formKey.currentState!.validate()) {
              print("save");
              saveInfo();
              Future.delayed(Duration(milliseconds: 500), () {
                Fluttertoast.showToast(msg: "Changes saved");
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => managerUsers()));
              });

            }
          },
          child: const Text("Save",
            textAlign: TextAlign.center,
            style: TextStyle(

                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text("Edit User Details",), centerTitle: true,backgroundColor:santanderRed),

      body: Center(

          child: SingleChildScrollView(
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

                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Text(
                                'Update Details ',
                                style: TextStyle(
                                  fontSize: 40,
                                  foreground: Paint()
                                    ..style = PaintingStyle.fill
                                    ..color = santanderRed,
                                ),
                              ),
                            ),
                            //FORM TO FILL OUT
                            SizedBox(height: 12),
                            Text("Fill out the relevant fields you wish to update",style: TextStyle(color: santanderDarkRed,fontWeight: FontWeight.bold),),
                            SizedBox(height: 25),
                            firstNameField,
                            SizedBox(height: 25),
                            lastNameField,
                            SizedBox(height: 25),
                            Text("Is this user an admin?"),
                            adminDropDown,
                            SizedBox(height: 25),
                            saveButton,

                          ],
                        )
                    )

                ),

              )
          )
      ),
    );
  }
  void saveInfo() async {

    //only update details if values are valid
    if (_formKey.currentState!.validate()) {

      //UPDATE FIRST NAME
      String updateFirstName = editUser.toMap().update(
          'firstName', (value) => firstNameController.text.toString());
      if (updateFirstName.isNotEmpty) {
        FirebaseFirestore.instance.collection('users').doc(editUser.uid)
            .update({'firstName': updateFirstName});
      }

      //UPDATE LAST NAME
      String updateLastName = editUser.toMap().update(
          'lastName', (value) => lastNameController.text.toString());
      if (updateLastName.isNotEmpty) {
        FirebaseFirestore.instance.collection('users').doc(editUser.uid)
            .update({'lastName': updateLastName});
      }

      if(dropdownValue=="Yes"){

        String updateAdmin=editUser.toMap().update(
            'accountType', (value) => "admin" );

        if (updateAdmin.isNotEmpty) {
          FirebaseFirestore.instance.collection('users').doc(editUser.uid)
              .update({'accountType': "admin"});
        }
      }
    }
  }
}