class userModel{

  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? accountType;
  bool? colorBlind;


  userModel( {this.uid,this.email,this.firstName,this.lastName,this.accountType,this.colorBlind});

  //recieve data from server
  factory userModel.fromMap(map)
  {
    return userModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      colorBlind: map['colorBlind'],
      accountType: map['accountType'],
    );
  }

//  send data to server
  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName':lastName,
      'accountType':accountType,
      'colorBlind':colorBlind,
    };
  }

}