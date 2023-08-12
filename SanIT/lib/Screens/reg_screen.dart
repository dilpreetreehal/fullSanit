import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sanit/Model/user_models.dart';
import 'package:sanit/Screens/user%20screens/home_screen.dart';

class regScreen extends StatefulWidget {
  const regScreen({Key? key}) : super(key: key);

  @override
  _regScreenState createState() => _regScreenState();
}

class _regScreenState extends State<regScreen> {
  final auth = FirebaseAuth.instance;

  //form key
  final _formKey = GlobalKey<FormState>();

  //input variables
  final firstNameController = new TextEditingController();
  final lastNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();

  String dropdownValue = 'No';
  bool colourBlind = false;
  //set colours
  static const santanderRed = Color(0xffec0000);
  static const santanderDarkRed = Color(0xffcc0000);

  @override
  Widget build(BuildContext context) {

    //first name field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        //regex for names longer than 3 letters
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid First Name(Min. 3 Character)");
        }
      },
      onSaved: (value) {
        firstNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person_add_alt_1_sharp),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'First Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //last name field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Last Name is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Last Name(Min. 3 Character)");
        }
      },
      onSaved: (value) {
        lastNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person_add_alt_1_sharp),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //last name field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@santander.com").hasMatch(value)) {
          return ("Please enter a valid santander email address "
              '\n'
              "e.g. JohnDoe@santander.com");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //PASSWORD field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //CONFIRM PASS field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      keyboardType: TextInputType.name,
      validator: (value) {
        //makes sure passwords match
        if (confirmPasswordController.text != passwordController.text) {
          return ("Passwords do not match");
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //DROP DOWN FOR COLOUR BLIND CHECK
    final colorDropDown = DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        alignment: Alignment.center,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          // print(dropdownValue);
        });
      },
      items: <String>[
        'No',
        'Yes',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    //SIGN UP BUTTON
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: santanderRed,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailController.text, passwordController.text);
          },
          child: const Text(
            "Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
      
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            //BACK ICON 
            icon: Icon(Icons.arrow_back, color: santanderDarkRed),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
            //SCROLLABLE BODY
            child: SingleChildScrollView(
                child: Container(
                    margin:
                        new EdgeInsets.symmetric(horizontal: 36.0, vertical: 0),
                    color: Colors.white,
                    //     padding: const EdgeInsets.all(36.0),
                    // child: Padding(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          //SET TO DEVICE DIMENSIONS
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Text(
                                //TITLE
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 40,
                                  foreground: Paint()
                                    ..style = PaintingStyle.fill
                                    ..color = santanderRed,
                                ),
                              ),
                            ),

                            //ADD FORM FIELDS
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
                            Text("Are you colour blind?"),
                            colorDropDown,
                            SizedBox(height: 25),
                            signUpButton,
                            SizedBox(height: 15),
                          ],
                        ))))
            // )
            ));
  }

  void signUp(String email, String password) async {
    //VALIDATES CREDENTIALS
    if (_formKey.currentState!.validate()) {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFireStore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  void postDetailsToFireStore() async {
    //SET COLOUR BLIND STATUS
    if (dropdownValue == "Yes") {
      colourBlind = true;
    }
    //  call firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    //  call user model

    userModel userModels = userModel();
    // send values
    userModels.email = user!.email;
    userModels.uid = user.uid;
    userModels.firstName = firstNameController.text;
    userModels.lastName = lastNameController.text;
    userModels.accountType = 'user';
    userModels.colorBlind = colourBlind;

    //MAP VALUES AND INPUT TO DB
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModels.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");

    //GO TO HOME PAGE
    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => homePage()), (route) => false);
  }
}
