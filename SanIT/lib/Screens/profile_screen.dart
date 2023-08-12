import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:local_auth/local_auth.dart';

import 'package:sanit/Model/user_models.dart';
import 'package:sanit/Screens/user%20screens/home_screen.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {

  //FORM KEY
  final _formKey = GlobalKey<FormState>();
  //FIREBASE VARS
  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  //VAR FOR MODEL
  userModel loggedInUser = userModel();


  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmPasswordController = new TextEditingController();

  static const santanderRed = Color(0xffec0000);
  static const santanderDarkRed = Color(0xffcc0000);


  //BIOMETRICS
  LocalAuthentication localAuth = LocalAuthentication();
  late bool _canCheckBio;
  late List<BiometricType> availableBio;
  String authorised = "Not Authorised";

  Future<void> checkBio() async {
    bool canCheckBio;
    try {
      //CHECKS BIO EXISTS ON DEVICE
      canCheckBio = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      //IS AVAIL
      canCheckBio = _canCheckBio;
    });
  }

  Future<void> _getAvailBio() async {
    //GETS THE TYPE OF BIO ON DEVICE - PIN FACE ETC
    List<BiometricType> availBio;
    try {
      availableBio = await localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      availBio = availableBio;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;

    //NO BIO AVAIL
    if (availableBio.isEmpty) {
      Fluttertoast.showToast(msg: "NO biometrics");
    } else {
      try {
        //FINGER PRINT BIO
        authenticated = await localAuth.authenticate(
            localizedReason: "scan finger",
            useErrorDialogs: true,
            stickyAuth: false);
      } on PlatformException catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
      if (!mounted) return;
      setState(() {
        //SET STATE OF ATTEMPT
        authorised = authenticated ? "Success" : "you failed";
        //updates details if passes test
        if (authenticated) {
          //IF ACCEPTED USER CAN PROCEED
          saveInfo();
          Future.delayed(Duration(milliseconds: 500), () {
            Fluttertoast.showToast(msg: "Changes saved");
            Navigator.of(context).pushReplacement(
                //BACK TO HOME PAGE
                //NEW HOME SO DETAILS REFRESH
                MaterialPageRoute(builder: (context) => new homePage()));
          });
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //QUERY DB FOR CURRENT LOGGED IN USER
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      //    MAPS USER TO LOGGEDIN
      this.loggedInUser = userModel.fromMap(value.data());
      setState(() {});
    });

    //CHECK BIO
    checkBio();
    _getAvailBio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //FIELDS CAN BE NULL AS NOT EACH FORM REQUIRES UPDATING EVERY SINGLE TIME = CHANGE TO VALIDATION

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
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "${loggedInUser.firstName}",
          hintStyle: TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
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
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_box),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "${loggedInUser.lastName}",
          hintStyle: TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //EMAIL FIELD
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {}
        if (!RegExp("^[a-zA-Z0-9+_.-]+@santander.com").hasMatch(value) &&
            value.isNotEmpty) {
          return ("Please enter a valid santander email address "
              '\n'
              "e.g. JohnDoe@santander.com");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      style: TextStyle(color: Colors.black),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "${loggedInUser.email}",
          hintStyle: TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //UPDATE PASSWORD

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {}
        if (!regex.hasMatch(value) && value.isNotEmpty) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "New Password",
          hintStyle: TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //CONFIRM PASSWORD
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (confirmPasswordController.text != passwordController.text) {
          return ("Passwords do not match");
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          hintStyle: TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final saveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: santanderRed,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _authenticate();
            }
          },
          child: const Text(
            "Save",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            "Profile Page",
          ),
          centerTitle: true,
          backgroundColor: santanderRed),
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
                              //PAGE TITLE
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
                            SizedBox(height: 12),
                            //SUBTITLE
                            Text(
                              "Fill out the relevant fields you wish to update",
                              style: TextStyle(
                                  color: santanderDarkRed, fontWeight: FontWeight.bold),
                            ),
                            //FORM DETAILS
                            SizedBox(height: 25),
                            firstNameField,
                            SizedBox(height: 25),
                            lastNameField,
                            SizedBox(height: 25),
                            emailField,
                            SizedBox(height: 25),
                            passwordField,
                            SizedBox(height: 25),
                            confirmPasswordField,
                            SizedBox(height: 25),
                            saveButton,
                          ],
                        ))),
              ))),
    );
  }

  void saveInfo() async {

    //only update details if values are valid
    if (_formKey.currentState!.validate()) {
      //UPDATE FIRST NAME
      String updateFirstName = loggedInUser
          .toMap()
          .update('firstName', (value) => firstNameController.text.toString());
      if (updateFirstName.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'firstName': updateFirstName});
      }

      //UPDATE LAST NAME
      String updateLastName = loggedInUser
          .toMap()
          .update('lastName', (value) => lastNameController.text.toString());
      if (updateLastName.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'lastName': updateLastName});
      }

      //UPDATE EMAIL ADDRESS
      //update user model
      String updateEmail = loggedInUser
          .toMap()
          .update('email', (value) => emailController.text.toString());
      //update firebase
      if (updateEmail.isNotEmpty) {
        FirebaseAuth.instance.currentUser?.updateEmail(updateEmail);

        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'email': updateEmail});
      }

      //  UPDATE PASSWORD
      if (passwordController.text.isNotEmpty) {
        FirebaseAuth.instance.currentUser
            ?.updatePassword(passwordController.text);
      }
    }
  }
}
