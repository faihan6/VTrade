import 'package:appliances/BuyerProductCard.dart';
import 'package:appliances/ChangePassword.dart';
import 'package:appliances/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DatabaseManager.dart';
import 'HomePage.dart';
import 'LoginPage.dart';
import 'Product.dart';
import 'User.dart';

class BuyerHomePage extends StatefulWidget {
  @override
  _BuyerHomePageState createState() => _BuyerHomePageState();

  User CurrentUser;

  BuyerHomePage(String userEmail)
  {
    CurrentUser = User(userEmail,'');
  }
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  @override

  List ProductList = new List();
  var placeHolder;

  Widget build(BuildContext context)  {
    RetriveProducts(widget.CurrentUser.Email);
    return FutureBuilder(
      future: RetriveProducts(widget.CurrentUser.Email),
      builder: (context,snapshot){
        switch(snapshot.connectionState)
        {
          case ConnectionState.none:
            return Text('none');
          case ConnectionState.active:
            return Center(child: Text('active'));
          case ConnectionState.waiting:
            return Scaffold(body: Center(child: Container(
                height: 500, width: 500,
                child: Text("")
            )
            ),
            );
          case ConnectionState.done:
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Column(
                  children: <Widget>[
                    Text('Signed in as Buyer',style: TextStyle(fontSize: 10,color: Colors.white),),
                    SizedBox(height: 4,),
                    Text(
                      widget.CurrentUser.Email,
                      style: TextStyle(fontSize: 15,color: Colors.white),
                    ),
                  ],
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: PopupMenuButton<dynamic>(
                        icon: Icon(Icons.more_vert,color: Colors.white,),
                        onSelected: (dynamic result) async{
                          print(result);
                          if(result == 50)
                          {
                            SharedPreferences myPrefs = await SharedPreferences.getInstance();
                            myPrefs.setString('LoginMode', 'SellerHomePage');
                            myPrefs.setString('LoggedInUser', widget.CurrentUser.Email);
                           Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => HomePage(widget.CurrentUser.Email)),
                      (route) => false);
                          }
                          if(result == 100)
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangePassword(widget.CurrentUser.Email)),
                            );
                          }
                          if(result == 200)
                          {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool('LoggedIn', false);
                            prefs.setString('LoggedInUser', '');

                            print('LoginPage');
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          }
                        } ,
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
                          const PopupMenuItem<dynamic>(value: 50,child: Text('Switch to Seller Account')),
                          const PopupMenuItem<dynamic>(value: 100,child: Text('Change Password')),
                          const PopupMenuItem<dynamic>(value: 200,child: Text('Sign Out')),


                        ],
                      )
                  ),
                ],
              ),
              body: Container(
                color: Colors.white12,
                padding: EdgeInsets.fromLTRB(0,0,0,0),
                child: placeHolder
              ),
            );
          default:
            return Center(child: Text('default'));
        }
      },
    );
  }

  Future RetriveProducts(String email) async
  {
    List<Widget> PredefinedList =
    [

    ];
    ProductList = await DBProvider.instance.queryAllProducts();
    ProductList = ProductList.map((e) => MaptoProduct(e)).toList();
    ProductList = PredefinedList + ProductList;

    placeHolder = ListView(
        cacheExtent: 2400,
        children: ProductList
    );

    if(ProductList.length == 0)
    {
      placeHolder = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Looks Like Nobody is selling their product yet!"),
          SizedBox(height: 10,width: double.infinity,),
          Text("Please Comeback after some time." ),
        ],
      );
    }
    print(ProductList);

    print(ProductList);
  }

  BuyerProductCard MaptoProduct(Map m)
  {
    Product product = new Product(
        id: m['id'],
        productName: m['name'],
        description: m['details'],
        price: m['price'],
        createdBy: m['createdby'],
        imageLocation: m['imagelocation'],
        imageMaxHeight: 250
    );
    return BuyerProductCard(product,immediateReload);

  }



  Future reload() async
  {
    await Future.delayed(Duration(seconds: 2));
    setState(() {

    });
  }

  immediateReload()
  {
    setState(() {

    });
  }

//  Widget _selectPopup() => PopupMenuButton<int>(
//    itemBuilder: (context) => [
//      PopupMenuItem(
//        value: 1,
//        child: Text("First"),
//      ),
//      PopupMenuItem(
//        value: 2,
//        child: Text("Second"),
//      ),
//    ],
//    initialValue: 2,
//    onCanceled: () {
//      print("You have canceled the menu.");
//    },
//    onSelected: (value) {
//      print("value:$value");
//    },
//    icon: Icon(Icons.list),
//  );
}





