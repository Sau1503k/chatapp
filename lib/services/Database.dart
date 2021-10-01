import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserbyusername(String username)async{
    return await FirebaseFirestore.instance.collection("users").
    where("name",isEqualTo: username).get();

  }
  getUserbyuserEmail(String userEmail)async{
    return await FirebaseFirestore.instance.collection("users").
    where("name",isEqualTo: userEmail).get();

  }
  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e){
      print(e.toString());
    });

  }
  createChatRoom(String chatroomId,chatRoomMap){
    FirebaseFirestore.instance.collection("chatroom").doc(chatroomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }
  addConversationMessages(String chatRoomId,messageMap){
    FirebaseFirestore.instance.collection("chatroom").doc(chatRoomId).collection("chats").add(messageMap).catchError((e){print(e.toString());});
  }
  getConversationMessages(String chatRoomId)async{
    return await FirebaseFirestore.instance.collection("chatroom").doc(chatRoomId).collection("chats").orderBy("time",descending: false).snapshots();
  }
  getchatrooms(String username)async{
    return await FirebaseFirestore.instance.collection("chatroom").
    where("users",arrayContains:username ).snapshots();
  }
}