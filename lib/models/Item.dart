import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:bilinguo_flutter/models/AppState.dart';
import './User.dart';

class Item {
  String id;
  String name;
  String description;
  int price;
  String imgUrl;

  Item({ String id, String name, String description, int price, String imgUrl }) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.price = price;
    this.imgUrl = imgUrl;
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imgUrl: json['imgUrl'],
    );
  }

  static Future<User> buyItem(ViewModel viewModel, Item item) async {
    try {
      const url = "https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/buyItem";
      // print('I' + viewModel.currentUser.email);
      await http.post(url, body: {
        'userEmail': viewModel.currentUser.email,
        'itemId': item.id,
        'itemPrice': item.price.toString()
      });
      // await http.post(Uri.encodeFull(url), body: json.encode({
      //   'userEmail': viewModel.currentUser.email.toString(),
      //   'itemId': item.id,
      //   'itemPrice': item.price
      // }));
      // print('II');
      User updatedUser = await User.getUserByToken(viewModel.currentUser.token);
      // print('III' + updatedUser.email);
      viewModel.onSetCurrentUser(updatedUser);
      return updatedUser;
    }
    catch(err) {
      print('oof buy item ' + err.toString());
    }
  }
}