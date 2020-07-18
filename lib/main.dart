import 'package:appliances/BuyerHomePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'LoginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loginMode = prefs.getString('LoginMode');
  var loggedInUser = prefs.getString('LoggedInUser');
  print(loginMode);

  var loginPage;
  if(loginMode == 'BuyerHomePage')
    loginPage = BuyerHomePage(loggedInUser);
  else if(loginMode == 'SellerHomePage')
    loginPage = HomePage(loggedInUser);
  else loginPage = Login();

  runApp(MaterialApp(
      home: loginPage
    )
  );
}



