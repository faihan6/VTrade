import 'dart:io';

import 'package:flutter/material.dart';

import 'Product.dart';

class FullScreenProductCard extends StatelessWidget {

  Product product;
  FullScreenProductCard(Product p)
  {
    product = p;
    product.imageMaxHeight = double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Text(product.name),
              SizedBox(height: 7,),
              Text("₹ "+ product.price.toString(), style: TextStyle(fontSize: 13),),
            ],
          ),
        ),
        centerTitle: true,

      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  child: Image.file(File(product.imageLocation))
              )
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
              child: Text(product.details))
        ],
      ),
//      bottomNavigationBar: BottomAppBar(
//        child: Text(
//            product.price.toString(),
//          style: TextStyle(fontSize: 20, color: Colors.white),
//        ),
//        color: Colors.blue,
//      ),
    );
  }
}
