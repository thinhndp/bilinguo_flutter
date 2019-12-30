import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Topic {
  String id;
  String name;
  String backgroundColorGradientTop;
  String backgroundColorGradientBottom;
  String backgroundColor;

  Topic({String id, String name, String backgroundColorGradientTop,
      String backgroundColorGradientBottom, String backgroundColor}) {
    this.id = id;
    this.name = name;
    this.backgroundColorGradientTop = backgroundColorGradientTop;
    this.backgroundColorGradientBottom = backgroundColorGradientBottom;
    this.backgroundColor = backgroundColor;
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
      backgroundColor: json['backgroundColor'],
    );
  }


  // TODO: Move to another file

  static Future<Topic> fetchTopic(id) async {
    final res = await http.get('http://localhost:5000/fb-cloud-functions-demo-4de69/us-central1/getTopics' + id);
    if (res.statusCode == 200) {
      return Topic.fromJson(json.decode(res.body));
    }
    else {
      throw Exception('Failed to load Topic');
    }
  }

  static Future<List<Topic>> fetchTopics() async {
    try {
      final res = await http.get('https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/getTopics');
      List<Topic> topics = json.decode(res.body).map<Topic>((model) => Topic.fromJson(model)).toList();
      return topics;
      // if (res.statusCode == 200) {
      // }
    }
    catch (err) {
      print('oof ' + err.toString());
    }
    // else {
    //   // throw Exception('Failed to load Topics');
    // }
  }

  // static List<Topic> fetchTopics() {
  //   http.get('https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/getTopics')
  //   .then((res) {
  //     List<Topic> topics = json.decode(res.body).map((Map model) => Topic.fromJson(model)).toList();
  //     return topics;
  //   })
  //   .catchError((err) {
  //     throw Exception('Failed to load Topics');
  //   });
  // }
}