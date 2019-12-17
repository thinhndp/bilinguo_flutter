import 'Item.dart';

class ItemGroup {
  String name;
  List<Item> items;

  ItemGroup(String name, List<Item> items) {
    this.name = name;
    this.items = items;
  }
}