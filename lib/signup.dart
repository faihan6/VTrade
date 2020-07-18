import 'package:appliances/DatabaseManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'User.dart';


class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  
  String SignupStatusString = '';

  User newUser;


  @override
  Widget build(BuildContext context) {

    final EmailController = new TextEditingController();
    final PasswordController0 = new TextEditingController();
    final PasswordController1 = new TextEditingController();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50,),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 30,
                onPressed: (){
                  Navigator.pop(context);
                },

              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30,),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        //padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Text("Just a Few details..",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                      SizedBox(height: 5,),
                      Container(
                        //padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Text("and we are good to go!",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                      Container(
                        //padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Text("Use the same account for Buying and Selling",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                      SizedBox(height: 80,)

                    ],
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: "Enter new Email"
                  ),
                  controller: EmailController,
                ),
                SizedBox(height: 30,),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Enter new Password"
                  ),
                  controller: PasswordController0,
                ),
                SizedBox(height: 30,),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Enter new Password again"
                  ),
                  controller: PasswordController1,
                ),
                SizedBox(height: 30,),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Text(
                            SignupStatusString,
                            style: TextStyle(color: Colors.red),
                          )
                      ),
                      RaisedButton(
                        onPressed:() async {

                          if(PasswordController0.text != PasswordController1.text)
                          {
                            print("Passwords Do not Match!");
                            setState(() {
                              SignupStatusString = 'Passwords Do not Match!';
                            });
                          }
                          else if((EmailController.text.contains('@') && EmailController.text.contains('.')) == false)
                          {
                              print("Entered Email is not a Valid Email");
                              setState(() {
                                SignupStatusString = 'Entered Email is not a Valid Email';
                              });
                            }
                          else
                          {
                            newUser = new User(EmailController.text, PasswordController0.text);
                            bool res = await InsertUserIntoTable(newUser);
                            print(res);
                            if(res == true)
                              {
                                print('New User Successfully Created');
                                setState(() {
                                  SignupStatusString = 'New User Successfully Created! Please Go back and Login';
                                });
                              }
                            else
                              {
                                print('There is already an user with the same Email ID');
                                setState(() {
                                  SignupStatusString = 'There is already an user with the same Email ID';
                                });
                              }
                          }
                          DBProvider.instance.queryAll();
                        },
                        child: Text("Sign Up"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.blue,
                        textColor: Colors.white,
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                )

              ],
            ),
          ),
        ],
      )

    );
  }

  Future<bool> InsertUserIntoTable(User newUser) async
  {
    bool res = await DBProvider.instance.insert(
        {'email':newUser.Email,'password':newUser.Password}
    );
    return res;

  }
}
