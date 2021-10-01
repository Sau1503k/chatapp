import 'package:chatapp/Widget/widget.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/Database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController=new TextEditingController();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  Stream<QuerySnapshot> chatmessageStream;
  Widget ChatMessageList(){
    return StreamBuilder(stream: chatmessageStream,builder:(context,snapshot){
      return snapshot.hasData ? ListView.builder(itemCount: snapshot.data.docs.length,itemBuilder: (context,index){
        return MessageTile(snapshot.data.docs[index]["message"],snapshot.data.docs[index]["sendby"]==Constants.myname);

      },):Container(child:Center(child: Text("no worry only worry",style: TextStyle(color: Colors.white),)));
    });

  }
  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap={
        "message":messageController.text,
        "sendby":Constants.myname,
        "time":DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text="";
    }
  }
  @override
  void initState() {

      databaseMethods.getConversationMessages(widget.chatRoomId).then((val){
        setState(() {
          chatmessageStream=val;
        });
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [ Container(alignment: Alignment.topCenter,height:MediaQuery.of(context).size.height-180,
              child: ChatMessageList()),Container(alignment: Alignment.bottomCenter,
            child: Container(color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(vertical:24,horizontal: 16),
                child:Row(
                  children: [Expanded(child: TextField(
                    controller: messageController,
                    style: TextStyle(
                        color: Colors.white
                    ),decoration: InputDecoration(
                        hintText: "Message..",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none
                    ),),),
                    GestureDetector(onTap: (){
                      sendMessage();
                    },
                      child: Container(height:40,width: 40,padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)]
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          child: Image.asset("assets/images/send.png",fit: BoxFit.cover,)),
                    )],
                )
            ),
          )],
        ),
      ),
    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool issendbyme;
  MessageTile(this.message,this.issendbyme);
  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: issendbyme ? 0 : 24,
        right: issendbyme ? 24 : 0),width: MediaQuery.of(context).size.width,
      alignment: issendbyme?Alignment.centerRight:Alignment.centerLeft,
      child: Container(margin: issendbyme
          ? EdgeInsets.only(left: 30)
          : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(
              top: 17, bottom: 17, left: 20, right: 20),decoration: BoxDecoration(
          borderRadius: issendbyme ? BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
          ) :
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)),
        gradient: LinearGradient(
          colors:issendbyme ? [
            const Color(0xff007EF4),
            const Color(0xff2A75BC)
          ]
              : [
            const Color(0x1AFFFFFF),
            const Color(0x1AFFFFFF)
          ],
        )
      ),
        child: Text(message,style:TextStyle(
          color: Colors.white,
          fontSize: 17
        ),),
      ),
    );
  }
}

