import 'dart:io';

import 'package:flutter/cupertino.dart';

class Product
{
  int id;
  String name;
  String details;
  int price;
  String createdBy;
  String imageLocation;
  Image image;
  double imageMaxHeight;

  Product({int id, String productName, String description, int price, String createdBy,String imageLocation, Image productImage,this.imageMaxHeight})
  {
    this.id = id;
    this.name = productName;
    this.details = description;
    this.price = price;
    this.createdBy = createdBy;
    this.imageLocation = imageLocation;
    this.image = Image.file(File(imageLocation),height: imageMaxHeight,);
  }

  int productSortById(Product a, Product b)
  {
    if(a.id < b.id) return -1;
    else if(a.id > b.id) return 1;
    else return 0;
  }

}