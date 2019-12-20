import 'package:bilinguo_flutter/utils/HexColor.dart';
import 'package:flutter/material.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

_renderButton(){
  return Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () {
                //Navigator.of(context).pushNamed(HomePage.tag);
              },
              padding: EdgeInsets.all(12),
              color: Colors.white,
              child: Text('CHỈNH SỬA', style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () {
                //Navigator.of(context).pushNamed(HomePage.tag);
              },
              padding: EdgeInsets.all(12),
              color: Colors.white,
              child: Text('ĐĂNG XUẤT', style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    ],
  );
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 57,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.black12,
                blurRadius: 2.0,
              ),],
              border: Border(bottom: BorderSide(color: Colors.grey[300], width: 2)),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    "Thảo luận",
                    style: TextStyle(
                      color: HexColor("1cb0f6"),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.search),
                    tooltip: 'Tìm kiếm bài viết',
                    color: HexColor("1cb0f6"),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
         Container(
           padding: EdgeInsets.all(20),
           child: Column(
             children: <Widget>[
               Column(
                 children: <Widget>[
                   Row(
                     children: <Widget>[
                       Text("Hồ sơ của bạn",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                     ],
                   ),
                   SizedBox(height: 10,),
                   CircleAvatar(
                     radius: 40,
                     backgroundImage: AssetImage("assets/globe.png"),
                   ),
                   SizedBox(height: 10,),
                   Row(
                     children: <Widget>[
                       Text("Tên",style: TextStyle(fontSize: 20),),
                     ],
                   ),
                   SizedBox(height: 10,),
                   TextFormField(
                     autofocus: false,
                     enabled: false,
                     initialValue:'Ricardo Milos',
                     decoration: InputDecoration(
                       filled: true,
                       fillColor: Color(0xffeeeeee),
                       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                     ),),
                   SizedBox(height: 10,),
                   Row(
                     children: <Widget>[
                       Text("Username",style: TextStyle(fontSize: 20),),
                     ],
                   ),
                   SizedBox(height: 10,),
                   TextFormField(
                     autofocus: false,
                     enabled: false,
                     initialValue: 'ricardo_milos',
                     decoration: InputDecoration(
                       filled: true,
                       fillColor: Color(0xffeeeeee),
                       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                     ),),
                   SizedBox(height: 10,),
                   Row(
                     children: <Widget>[
                       Text("Email",style: TextStyle(fontSize: 20),),
                     ],
                   ),
                   SizedBox(height: 10,),
                   TextFormField(
                     enabled: false,
                     autofocus: false,
                     initialValue: 'ricardo_milos@gmail.com',
                     decoration: InputDecoration(
                       filled: true,
                       fillColor: Color(0xffeeeeee),
                       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                     ),),
                   SizedBox(height: 10,),
                   _renderButton(),
                 ],
               ),
             ],
           ),
         )
        ],
      ),
    );
  }
}
