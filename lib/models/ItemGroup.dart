import 'Item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ItemGroup {
  String id;
  String name;
  List<Item> items;

  ItemGroup({ String id, String name, List<Item> items }) {
    this.id = id;
    this.name = name;
    this.items = items;
  }

  factory ItemGroup.fromJson(Map<String, dynamic> json) {
    return ItemGroup(
      id: json['id'],
      name: json['name'],
      items: (json['items']).toList().map<Item>((itemJson) => Item.fromJson(itemJson)).toList(),
    );
  }

  static Future<List<ItemGroup>> fetchItemGroups() async {
    try {
      final res = await http.get("https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/getItems");
      List<ItemGroup> itemGroups = json.decode(res.body).map<ItemGroup>((model) => ItemGroup.fromJson(model)).toList();
      print(itemGroups.length);
      return itemGroups;
    }
    catch (err) {
      print('oof err fetch items ' + err.toString());
    }
  }
}