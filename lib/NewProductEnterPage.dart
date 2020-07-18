import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'DatabaseManager.dart';
import 'HomePage.dart';
import 'Product.dart';


class NewProductEnterPage extends StatefulWidget {
  @override
  _NewProductEnterPageState createState() => _NewProductEnterPageState();

  String email;

  NewProductEnterPage(String e,)
  {
    this.email = e;
  }
}

class _NewProductEnterPageState extends State<NewProductEnterPage> {
  @override
  String statusText = '';
  final picker = ImagePicker();

  TextEditingController ProductNameController = new TextEditingController();
  TextEditingController DetailsController = new TextEditingController();
  TextEditingController PriceController = new TextEditingController();

  String productName = 'default';
  String chosenFilePath = '';
  String newFilePath = 'New File Path';
  
  Widget build(BuildContext context) {

    Product product;

    productImagesDirectory();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title:Text('Create New Product'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100,),
            TextField(
              decoration: InputDecoration(labelText: "Product Name"),
              controller: ProductNameController,
            ),
            TextField(
              maxLines: 6,
              decoration: InputDecoration(
                  labelText: "Details"
              ),
              controller: DetailsController,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Price"),
              controller: PriceController,
            ),
            SizedBox(height: 25,),
            Text(statusText),
            Row(
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.image),
                      SizedBox(width: 6,),
                      Text('Select Image'),
                    ],
                  ),
                  onPressed: () async{
                    if (ProductNameController.text != '') {
                      productName = ProductNameController.text;
                      print(await getImage(ImageSource.gallery));
                      setState(() {});
                    }
                    else
                    {
                      setState(() {
                        statusText = 'Please Insert Product Name first!';
                      });
                    }
                  },
                ),
                SizedBox(width: 20,),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.camera_enhance),
                      SizedBox(width: 6,),
                      Text('Use Camera'),
                    ],
                  ),
                  onPressed: () async{
                    if (ProductNameController.text != '') {
                      productName = ProductNameController.text;
                      print(await getImage(ImageSource.camera));
                      setState(() {});
                    }
                    else
                    {
                      setState(() {
                        statusText = 'Please Insert Product Name first!';
                      });
                    }
                  },
                ),
              ],
            ),
            Text(chosenFilePath),
            //Text(newFilePath)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async
        {
          String name = ProductNameController.text;
          String details = DetailsController.text;
          String createdBy = widget.email;
          String imgLoc = newFilePath;
          int price;
          if(isNumeric(PriceController.text) && name != ''
              && details != '' && imgLoc != '')
            {

              price = int.parse(PriceController.text);
              product = Product(
                id: null,
                productName: name,
                description: details,
                  price: price,
                createdBy: createdBy,
                imageLocation: imgLoc
                );
              DBProvider.instance.insertIntoProductsTable(product);

              //DBProvider.instance.queryAllProducts(P);
              setState(() {
                statusText = "Product Added!";
              });
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => HomePage(widget.email)),
                      (route) => false);

            }
          else
            {
              setState(() {
                statusText = "Invalid/Incomplete Details.";
              });
            }

        },
      ),

    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<List> getImage(ImageSource imgsrc) async
  {
    var pickedFile  = await picker.getImage(source: imgsrc);
//    var croppedFile = await ImageCropper.cropImage(
//        sourcePath: pickedFile.path,
//        aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 1),
//        compressQuality: 50,
//        maxHeight: 600,
//        maxWidth: 300,
//        androidUiSettings: AndroidUiSettings(
//            toolbarColor: Colors.blue,
//            toolbarTitle: "Crop Image",
//            backgroundColor: Colors.white
//        )
//
//    );
    //print(croppedFile.path);
    File imageFile = File(pickedFile.path);
    var path = pickedFile.path;
    chosenFilePath = pickedFile.path;

    int extensionStartIndex = chosenFilePath.lastIndexOf('.') + 1;
    String extension = chosenFilePath.substring(extensionStartIndex);

    Directory newDirectory = await productImagesDirectory();
//    print('NEWPATH');
//    print(newPath.path);
    String newFileName = productName + '.$extension';
    newFilePath = join(newDirectory.path,newFileName);



    imageFile.copy(newFilePath);

    return [imageFile,path];
  }

  Future<Directory> deviceStoragePath() async
  {
    var directory;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      print('Android $release (SDK $sdkInt), $manufacturer $model');
      directory = getExternalStorageDirectory();
      return directory;

    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      print('$systemName $version, $name $model');
      directory = getApplicationDocumentsDirectory();
      return directory;
    }

  }

  Future<Directory> productImagesDirectory() async {
    Directory baseDir = await deviceStoragePath(); //only for Android

    String dirToBeCreated = join("Appliances Tracker","Product Images");
    String finalDir = join(baseDir.path, dirToBeCreated);
    var dir = Directory(finalDir);
    bool dirExists = await dir.exists();
    if(!dirExists){
      dir.create(recursive: true);
    }

    return dir;
  }

}
