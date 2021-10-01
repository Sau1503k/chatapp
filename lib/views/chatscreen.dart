import 'package:chatapp/helper/authentication.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/Database.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/views/conversation.dart';
import 'package:chatapp/views/search.dart';
import 'package:chatapp/views/signin.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  AuthMethod authMethod= new AuthMethod();
  DatabaseMethods databaseMethods=DatabaseMethods();
  Stream chatroomstream;
  Widget chatroomlist(){
    return  StreamBuilder(
      stream: chatroomstream,
      builder: (context,snapshot){
        return snapshot.hasData? ListView.builder(itemCount: snapshot.data.docs.length,itemBuilder: (context,index){
          return  chatroomtile(snapshot.data.docs[index]["chatroomId"].toString()
            .replaceAll("_", "").replaceAll(Constants.myname, ""),
              snapshot.data.docs[index]["chatroomId"]);

        }):Container();
      },
    );
  }
  @override
  void initState() {
    getUserInfo();


    super.initState();
  }
  getUserInfo()async{
    Constants.myname=await HelperFunction.getUserNamesharedpreference();
    setState(() {
      databaseMethods.getchatrooms(Constants.myname).then((val){
        setState(() {
          chatroomstream=val;
        });

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),actions: [ GestureDetector(onTap:(){
          authMethod.signout();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context)=>Authenticate()));
    },child: Icon(Icons.exit_to_app))],
        elevation: 0.0,
        centerTitle: false,
      ),
      body: chatroomlist(),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));

      },
        child: Icon(Icons.search),
      ),
    );
  }
}
class chatroomtile extends StatelessWidget {
  final String username;
  final String chatroomId;
  chatroomtile(this.username,this.chatroomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatroomId,
            )
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(username.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(username,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );;
  }
}

