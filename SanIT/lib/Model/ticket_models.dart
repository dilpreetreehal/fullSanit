class ticketModel{
  String? requesterUid;
  String? comment;
  String? requestType;
  String? status;
  String? uid;
  String? requestName;
  String? accountType;


  // String? accountType;

  ticketModel( {this.requesterUid,this.comment,this.status,this.requestType,this.uid,this.requestName,this.accountType});

  //recieve data from server
  factory ticketModel.fromMap(map)
  {
    return ticketModel(
      requesterUid: map['uid'],
      requestType: map['requestType'],
      comment: map['comment'],
      status: map['status'],
      requestName: map['requestName'],
      accountType: map['accountType'],


    );
  }

//  send data to server
  Map<String, dynamic> toMap(){
    return{
      'requesterUid': requesterUid,
      'comment': comment,
      'requestType': requestType,
      'status':status,
      'requestName':requestName,
      'accountType':accountType,

    };
  }

}

