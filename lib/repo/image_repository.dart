import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

class ImageRepository{
  Future <List<PixelfordImage>> getNetworkImages() async {
    try {
      var endpointUrl = Uri.parse('https://pixelford.com/api2/images');

      final response = await http.get(endpointUrl);

      if (response.statusCode == 200) {
        final List<dynamic> decodedList = jsonDecode(response.body) as List;

        final List<PixelfordImage> _imageList = decodedList.map((listItem) {
          return PixelfordImage.fromJson(listItem);
        }).toList();

        print(_imageList[0].urlFullsize);

        return _imageList;
      } else {
        throw Exception('API not succesful');
      }
    } on SocketException{
      throw Exception('No internet connection :(');
    } on HttpException{
      throw Exception('Couldn\'t retrieve the images! Sorry!');
    } on FormatException{
      throw Exception('Bad response format!');
    }

    catch(e){
      print(e);
      throw Exception('Unknown error');
    }
  }
}