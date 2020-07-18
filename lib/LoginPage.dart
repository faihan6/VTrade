import 'package:appliances/DatabaseManager.dart';
import 'package:appliances/HomePage.dart';
import 'package:flutter/material.dart';

import 'User.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  final EmailController = new TextEditingController();
  final PasswordController = new TextEditingController();
  String buttonText = "Default";
  String LoginStatusString = '';


  String ThisClassName = "From LoginPage : ";

  User CurrentUser;

  Widget build(BuildContext context) {

    final EmailController = new TextEditingController();
    final PasswordController = new TextEditingController();
  print('Building LoginPage');
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 160,),
          Container(
              padding: EdgeInsets.fromLTRB(50, 0, 0, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Welcome!",
                    style: TextStyle(fontSize: 50),
                  ),
                  Text("Please Login to Continue.",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )
          ),
          SizedBox(height: 50,),
          Container(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      labelText: "Email"
                  ),
                  controller: EmailController,
                ),
                SizedBox(height: 30,),
                TextField(
                  decoration: InputDecoration(
                      labelText: "Password"
                  ),
                  obscureText: true,
                  controller: PasswordController,

                )
              ],
            ),
          ),
          SizedBox(height: 30,),
          Container(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text(
                      LoginStatusString,
                      style: TextStyle(color: Colors.red),
                    )
                ),
                RaisedButton(
                  onPressed:() async {
                    CurrentUser = new User(EmailController.text, PasswordController.text);
                    if (await CheckEmailFormat(CurrentUser.Email) == true)
                    {
                      int state = await DBProvider.instance.CheckValidity(CurrentUser.Email, CurrentUser.Password);
                      print(state);
                      if(state == 1)
                      {
                        print('Login Success');
                        setState(() {
                          LoginStatusString = "Login Success!";
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(CurrentUser.Email)),
                        );

                      }
                      else
                      {
                        setState(() {
                          LoginStatusString = "Invalid Credentials. Please Try Again.";
                        });
                      }
                    }
                    else
                      {
                        setState(() {
                          LoginStatusString = "Invalid Email! Please Try again.";
                        });
                      }
                    //DBProvider.instance.queryAll();
                  },
                  child: Text("Login"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: Text(
                    "New User? Sign Up Here.",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                    ),

                  ),
                ),


              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> CheckEmailFormat(String email) async
  {
    int atIndex = email.indexOf('@');
    if(atIndex == -1) return false;

    String domain = email.substring(atIndex+1,email.length);
    print(ThisClassName + domain);
    if(domain.indexOf('.') > 0)
      {
        return true;
      }
    else
    {
      return false;
    }
  }
}