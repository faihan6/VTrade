import 'package:appliances/BuyerHomePage.dart';
import 'package:appliances/ChangePassword.dart';
import 'package:appliances/LoginPage.dart';
import 'package:appliances/NewProductEnterPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DatabaseManager.dart';
import 'LoginPage.dart';
import 'Product.dart';
import 'ProductCard.dart';
import 'User.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  User CurrentUser;

  HomePage(String userEmail)
  {
    CurrentUser = User(userEmail,'');
  }
}

class _HomePageState extends State<HomePage> {
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
                     Text('Signed in as Seller',style: TextStyle(fontSize: 10,color: Colors.white),),
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
                             myPrefs.setString('LoginMode', 'BuyerHomePage');
                             myPrefs.setString('LoggedInUser', widget.CurrentUser.Email);
                             Navigator.pushAndRemoveUntil(context,
                                 MaterialPageRoute(builder: (context) => BuyerHomePage(widget.CurrentUser.Email)),
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
                           const PopupMenuItem<dynamic>(value: 50,child: Text('Switch to Buyer Account')),
                           const PopupMenuItem<dynamic>(value: 100,child: Text('Change Password')),
                           const PopupMenuItem<dynamic>(value: 200,child: Text('Sign Out')),


                         ],
                       )
                   ),
                 ],
               ),
               body: RefreshIndicator(
                 onRefresh: reload,
                 child: Container(
                   color: Colors.white12,
                   padding: EdgeInsets.fromLTRB(0,0,0,0),
                   child: placeHolder
                 ),
               ),
               floatingActionButton: FloatingActionButton(
                 child: Icon(Icons.add),
                 onPressed: () async
                 {
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => NewProductEnterPage(widget.CurrentUser.Email)),
                   );
                 },
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
//      ProductCard(
//          Product(
//              id: 89,
//              productName: 'LG G6',
//              description: '''
//=> 13MP primary camera and 5MP front facing camera, wide angle dual camera with square camera mode and SNS (Social Network) Quick Access
//
//=> 18:9 Display: 14.47 centimeters (5.7-inch) FullVision display with 2880 x 1440 pixels resolution, Dolby Vision and HDR10
//
//=> Android v7 Nougat operating system with 2.35GHz Qualcomm Snapdragon 821 quad core processor, 4GB RAM, 64GB internal memory expandable up to 2TB and dual SIM (nano+nano) dual-standby (4G+4G)
//
//=> 3300mAH lithium-ion battery providing talk-time of 14 hours and standby time of 136 hours
//
//=> Water and dust resistant (IP68)
//
//=> 1 year manufacturer warranty for device and 6 months manufacturer warranty for in-box accessories including batteries from the date of purchase
//
//=> Customer Service Central number: 1800-315-9999 or 1800-180-9999
//''',
//                 price: 50000,
//              createdBy: 'Default',
//              imageLocation: '',
//              productImage: Image.asset('imageassets/LG G6.jpg')),
//              (){}
//      ),
//      ProductCard(
//          Product(
//              id: 89,
//              productName: 'LG G6',
//              description: '''
//=> 13MP primary camera and 5MP front facing camera, wide angle dual camera with square camera mode and SNS (Social Network) Quick Access
//
//=> 18:9 Display: 14.47 centimeters (5.7-inch) FullVision display with 2880 x 1440 pixels resolution, Dolby Vision and HDR10
//
//=> Android v7 Nougat operating system with 2.35GHz Qualcomm Snapdragon 821 quad core processor, 4GB RAM, 64GB internal memory expandable up to 2TB and dual SIM (nano+nano) dual-standby (4G+4G)
//
//=> 3300mAH lithium-ion battery providing talk-time of 14 hours and standby time of 136 hours
//
//=> Water and dust resistant (IP68)
//
//=> 1 year manufacturer warranty for device and 6 months manufacturer warranty for in-box accessories including batteries from the date of purchase
//
//=> Customer Service Central number: 1800-315-9999 or 1800-180-9999
//''',
//              price: 50000,
//              createdBy: 'Default',
//              imageLocation: '',
//              productImage: Image.asset('imageassets/LG G6.jpg')),
//              (){setState(() {
//                print(ProductList);
//                ProductList.removeAt(1);
//                print(ProductList);
//              });}
//      ),
    ];
    ProductList = await DBProvider.instance.queryAllProducts(createdByEmail: email);
    ProductList = ProductList.map((e) => MaptoProduct(e)).toList();
    ProductList = PredefinedList + ProductList;
    placeHolder = ListView(children: ProductList);

    if(ProductList.length == 0)
      {
        placeHolder = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Looks Like You haven't Added any Product yet!"),
            SizedBox(height: 10,width: double.infinity,),
            Text("Tap '+' to add a product so that others can see it" ),
          ],
        );
      }
    print(ProductList);
  }

  ProductCard MaptoProduct(Map m)
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
    print(product.imageMaxHeight);
    return ProductCard(product,immediateReload);

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





