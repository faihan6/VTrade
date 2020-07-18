import 'dart:io';

import 'package:appliances/FullScreenProductCard.dart';
import 'package:flutter/material.dart';

import 'Product.dart';

class BuyerProductCard extends StatefulWidget {
  @override
  _BuyerProductCardState createState() => _BuyerProductCardState();

  Product product;
  Function reloadParent;
  BuyerProductCard(Product p, Function deleteAction)
  {
    product = p;
    reloadParent = deleteAction;
  }

}

class _BuyerProductCardState extends State<BuyerProductCard> {
  @override
  bool imagePresenceState;
  Widget ImagePlace;
  String briefDescription;

  Widget build(BuildContext context) {
    print('widget building');

    return FutureBuilder(
      future: checkImageAvailability(File(widget.product.imageLocation)),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done)
          return Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: InkWell(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.grey,
                          child: Column(
                            children: <Widget>[Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "Posted By: " + widget.product.createdBy,
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                    )
                                ),


                              ],
                            ),],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 350,),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text(
                                    widget.product.name,
                                    style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0,20,0,20),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: ImagePlace
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: InkWell(
                                    child: Text(createBriefDescription(widget.product.details)),
                                    onTap: (){

                                    },
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Price: ₹" + widget.product.price.toString(),
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                  )
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FullScreenProductCard(widget.product)),
                );
              },
            ),
          );
        else return Container();
      },
    );
  }

  String createBriefDescription(String s)
  {
    int strlen = widget.product.details.length;
    if(strlen > 300)
      return widget.product.details.substring(0,300) + '... Read More';
    else
      return widget.product.details.substring(0,strlen);
  }

  Future checkImageAvailability(File f) async
  {
    imagePresenceState = await f.exists();
    print(imagePresenceState);
    if(imagePresenceState == false)
    {
      if(widget.product.imageLocation == '')
      {
        ImagePlace = widget.product.image;
      }
      else {
        ImagePlace = Container(
            padding: EdgeInsets.all(6),
            child: Center(child: Text("----Image not Found----")
            )
        );
      }
    }
    else
    {
      ImagePlace = widget.product.image;
    }
  }



}
