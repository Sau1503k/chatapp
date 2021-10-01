import 'package:chatapp/Widget/widget.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/Database.dart';
import 'package:chatapp/views/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
String _myname;

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController=TextEditingController();
  DatabaseMethods databaseMethods=DatabaseMethods();
  QuerySnapshot searchSnapshot;
  initiatesearch(){
    databaseMethods.getUserbyusername(searchTextEditingController.text).then((val){
      setState(() {
        searchSnapshot=val;
      });
    });
  }

  Widget searchList(){
    return searchSnapshot!=null ? ListView.builder(shrinkWrap: true,itemCount: searchSnapshot.docs.length,itemBuilder: (context,index){
      return SearchTile(username:searchSnapshot.docs[index]["name"] ,
        email:searchSnapshot.docs[index]["email"]  ,);
    }):Container();
  }
  @override
  void initState() {
    getUserInfo();

    super.initState();
  }
  createchatroomandstartconversation(String Username){
    if(Username!=Constants.myname){
      String chatroomId=getChatRoomId(Username,Constants.myname);
      List<String> users=[Username,Constants.myname];
      Map<String,dynamic> chatRoomMap={
        "users":users,
        "chatroomId":chatroomId
      };
      databaseMethods.createChatRoom(chatroomId,chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationScreen(chatroomId)));
    }else{
      print("you cannot send msg to yourself");
    }

  }
  Widget SearchTile({String username,String email }){
    return Container(padding: EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: Row(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username,style: simpleTextStyle(),),
                Text(email,style: simpleTextStyle(),)
              ],
            ),
            Spacer(),
            GestureDetector(onTap:(){

            } ,
              child: GestureDetector(onTap: (){
                createchatroomandstartconversation(username);

              },
                child: Container(padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                  child:Text("Message",style: simpleTextStyle(),) ,
                  decoration: BoxDecoration(color: Colors.blue,
                      borderRadius:BorderRadius.circular(20)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  getUserInfo()async{
    _myname= await HelperFunction.getUserNamesharedpreference();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(vertical:24,horizontal: 16),
              child:Row(
                children: [Expanded(child: TextField(controller: searchTextEditingController,
                style: TextStyle(
                  color: Colors.white
                ),decoration: InputDecoration(
                  hintText: "Search Username..",
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  border: InputBorder.none
                ),),),
                GestureDetector(onTap: (){
                  initiatesearch();
                },
                  child: Container(height:40,width: 40,padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0x36FFFFFF),
                      const Color(0x0FFFFFFF)]
                    ),
                    borderRadius: BorderRadius.circular(40)
                  ),
                      child: Image.asset("assets/images/search_white.png",fit: BoxFit.cover,)),
                )],
              )
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
