import 'package:chatapp/Widget/widget.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/Database.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/views/chatscreen.dart';
import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading= false;
  AuthMethod authmethods = new AuthMethod();
  DatabaseMethods databaseMethods=DatabaseMethods();
  HelperFunction helperFunction=HelperFunction();
  final formkey=GlobalKey<FormState>();
  TextEditingController usernameTextEditing=new TextEditingController();
  TextEditingController EmailTextEditing=new TextEditingController();
  TextEditingController PasswordTextEditing=new TextEditingController();

  signMeUp(){
    if(formkey.currentState.validate()){
      Map<String,String> userInfoMap={
        "name":usernameTextEditing.text,
        "email":EmailTextEditing.text
      };
      HelperFunction.saveUserEmailsharedpreference(EmailTextEditing.text);
      HelperFunction.saveUserNamesharedpreference(usernameTextEditing.text);
      setState(() {
        isLoading=true;
      });
      authmethods.signUpwithEmailandPassword(
          EmailTextEditing.text,PasswordTextEditing.text).then((val){

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunction.saveUserLoggedInsharedpreference(true);


        // print("${val.uid}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>ChatScreen()));
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
            child: Column(mainAxisSize: MainAxisSize.min,children: [
              Form(key: formkey,
                child: Column(
                  children: [TextFormField(validator: (val){
                    return val.isEmpty || val.length<2 ? "Please Provide UserName" : null;
                  },controller: usernameTextEditing,decoration:textFieldInputDecoration("UserName"),style: simpleTextStyle(),),
                    TextFormField(
                        validator:(val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null:"Enter correct Email";
                        }

                        ,controller: EmailTextEditing,decoration: textFieldInputDecoration("Email"),style: simpleTextStyle()),
                    TextFormField(obscureText: true,validator: (val){
                      return val.length>6 ? null:"password should be 6+ character";
                    }
                        ,controller: PasswordTextEditing,decoration:textFieldInputDecoration("Password"),style: simpleTextStyle()),],
                ),
              ),

              SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:10),
                child: Container(alignment: Alignment.centerRight
                  ,child:Text("Forgot Password",style:simpleTextStyle()) ,),
              ),
              SizedBox(height: 10,),
              GestureDetector(onTap: (){
                signMeUp();
              },
                child: Container(height: 50,width: MediaQuery.of(context).size.width,alignment:Alignment.center,child:Text("SignUp",style: simpleTextStyle(),),
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
                child:Text("Sign Up with google",style: TextStyle(color: Colors.black,
                    fontSize: 16),),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white70
                ),),
              SizedBox(height: 16,),

              Container(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Already have account?  ",
                    style:TextStyle(color: Colors.white,
                        fontSize: 17)),
                  GestureDetector(onTap: (){
                    widget.toggle();
                  },
                    child: Container(padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Signin Now",style:TextStyle(color:Colors.white,
                          fontSize: 17)),
                    ),
                  )],),),
              SizedBox(height: 70,)


            ],),),
        ),
      ),
    );
  }
}
