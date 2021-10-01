import 'package:chatapp/Widget/widget.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/Database.dart';
import 'package:chatapp/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatscreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethod authMethod=AuthMethod();
  TextEditingController EmailTextEditing=new TextEditingController();
  TextEditingController PasswordTextEditing=new TextEditingController();
  final formkey=GlobalKey<FormState>();
  bool isloading=false;
  QuerySnapshot snapshotUserInfo;
  DatabaseMethods databaseMethods=new DatabaseMethods();
  signIn(){
    if(formkey.currentState.validate()){
      HelperFunction.saveUserEmailsharedpreference(EmailTextEditing.text);
      setState(() {
        isloading=true;
      });
      databaseMethods.getUserbyuserEmail(EmailTextEditing.text).then((val){
        snapshotUserInfo=val;
        HelperFunction.saveUserNamesharedpreference(snapshotUserInfo.docs[0]["name"]);

      });
      authMethod.signInwithEmailandPassword(EmailTextEditing.text, PasswordTextEditing.text).then((val){
        if(val!=null){

          HelperFunction.saveUserLoggedInsharedpreference(true);


          // print("${val.uid}");
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>ChatScreen()));


        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:appBarMain(context) ,
      body: SingleChildScrollView(
        child: Container(alignment: Alignment.bottomCenter,
          height: MediaQuery.of(context).size.height-50,
          child: Container(padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(mainAxisSize: MainAxisSize.min,
            children: [
              Form(key: formkey,
                child: Column(mainAxisSize: MainAxisSize.min,children: [TextFormField(validator:(val){
                  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null:"Enter correct Email";
                },controller: EmailTextEditing,decoration: textFieldInputDecoration("Email"),style: simpleTextStyle(),),
                  TextFormField(obscureText: true,validator: (val){
                    return val.length>6 ? null:"password should be 6+ character";
                  },controller: PasswordTextEditing,decoration:textFieldInputDecoration("Password"),style: simpleTextStyle(),),
                  SizedBox(height: 8,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:10),
                    child: Container(alignment: Alignment.centerRight
                      ,child:Text("Forgot Password",style:simpleTextStyle()) ,),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(onTap: (){
                    signIn();

                  },
                    child: Container(height: 50,width: MediaQuery.of(context).size.width,alignment:Alignment.center,child:Text("SignIn",style: simpleTextStyle(),),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ],
                      )
                    ),),
                  ),
                  SizedBox(height: 15,),
                  Container(height: 50,width: MediaQuery.of(context).size.width,alignment:Alignment.center,
                    child:Text("Sign in with google",style: TextStyle(color: Colors.black,
                    fontSize: 16),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white70
                    ),),
                  SizedBox(height: 16,),
                  Container(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Don't have account?  ",
                      style:TextStyle(color: Colors.white,
                      fontSize: 17)),
                  GestureDetector(onTap: (){
                    widget.toggle();
                  },
                    child: Text("Register Now",style:TextStyle(color:Colors.white,
                    fontSize: 17)),
                  )],),),
                  SizedBox(height:100,)


                ],),
              ),
            ],
          ),),
        ),
      ),
    );
  }
}
