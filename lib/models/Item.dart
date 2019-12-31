import 'dart:convert';

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
}