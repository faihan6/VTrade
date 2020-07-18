import 'package:flutter/material.dart';

import 'DatabaseManager.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();

  String userEmail;

  ChangePassword(String ue)
  {
    userEmail = ue;
  }

}

class _ChangePasswordState extends State<ChangePassword> {
  @override

  String statusText = '';

  Widget build(BuildContext context) {

    TextEditingController OldPasswordController = new TextEditingController();
    TextEditingController NewPasswordController0 = new TextEditingController();
    TextEditingController NewPasswordController1 = new TextEditingController();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(

        backgroundColor: Colors.blue,
        title: Text(
          'Change Password',
          style: TextStyle(fontSize: 18,color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 150,),
            TextField(
              decoration: InputDecoration(labelText: "Enter Current Password"),
              controller: OldPasswordController,
              obscureText: true,
            ),
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                  labelText: "Enter New Password"
              ),
              controller: NewPasswordController0,
              obscureText: true,
            ),
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(labelText: "Enter New Password Again"),
              controller: NewPasswordController1,
              obscureText: true,
            ),
            SizedBox(height: 25,),
            Text(statusText),

            //Text(newFilePath)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async
        {
          if(NewPasswordController0.text != NewPasswordController1.text)
            {
              setState(() {
                statusText = 'New password does not match!';
              });
            }
            if(NewPasswordController0.text == NewPasswordController1.text)
              {
                String newPassword = NewPasswordController0.text;
                var queryStatus = await DBProvider.instance.CheckValidity(widget.userEmail, OldPasswordController.text);
                if(queryStatus == 1)
                  {
                    DBProvider.instance.update(widget.userEmail, newPassword);
                    setState(() {
                      statusText = 'Password Changed!';
                    });
                  }
                if(queryStatus == 2)
                {
                  setState(() {
                    statusText = 'Wrong Current Password!';
                  });
                }

              }
        },
      ),

    );
  }
}
