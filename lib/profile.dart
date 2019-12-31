import 'package:bilinguo_flutter/utils/HexColor.dart';
import 'package:flutter/material.dart';
import './mock-data.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditingProfile = false;

  _handleEditingTap() {
    setState(() {
      _isEditingProfile = true;
    });
  }

  _handleFinishEditingTap() {
    setState(() {
      _isEditingProfile = false;
    });
  }

  _renderButtons() {
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
                  !_isEditingProfile ? _handleEditingTap() : _handleFinishEditingTap();
                },
                padding: EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 14.0),
                elevation: 4,
                color: Colors.white,
                child: Text((!_isEditingProfile ? 'Chỉnh sửa' : 'Hoàn tất').toUpperCase(),
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    )),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
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
                padding: EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 14.0),
                elevation: 4,
                color: Colors.white,
                child: Text('Đăng xuất'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _renderHeader() {
    return (Container(
      height: 57,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: new BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2.0,
          ),
        ],
        border: Border(bottom: BorderSide(color: Colors.grey[300], width: 2)),
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Text(
              "Hồ sơ",
              style: TextStyle(
                color: HexColor("1cb0f6"),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          // Container(
          //   alignment: Alignment.centerRight,
          //   child: IconButton(
          //     icon: Icon(Icons.search),
          //     tooltip: 'Tìm kiếm bài viết',
          //     color: HexColor("1cb0f6"),
          //     onPressed: () {},
          //   ),
          // ),
        ],
      ),
    ));
  }

  _renderBody() {
    // return (Expanded(
    //   // height: double.infinity,
    //   child: SingleChildScrollView(
    //     padding: EdgeInsets.all(20),
    //     // mainAxisSize: MainAxisSize.max,
    //     // shrinkWrap: true,
    //     child: Column(
    //         mainAxisSize: MainAxisSize.max,
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: <Widget>[
    //           Column(
    //             children: <Widget>[
    //               Row(
    //                 children: <Widget>[
    //                   Text(
    //                     "Hồ sơ của bạn",
    //                     style:
    //                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               CircleAvatar(
    //                 radius: 40,
    //                 backgroundImage: AssetImage("assets/globe.png"),
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 children: <Widget>[
    //                   Text(
    //                     "Tên",
    //                     style: TextStyle(fontSize: 20),
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               TextFormField(
    //                 autofocus: false,
    //                 enabled: false,
    //                 initialValue: 'Ricardo Milos',
    //                 decoration: InputDecoration(
    //                   filled: true,
    //                   fillColor: Color(0xffeeeeee),
    //                   contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    //                   border: OutlineInputBorder(
    //                       borderRadius: BorderRadius.circular(16.0)),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 children: <Widget>[
    //                   Text(
    //                     "Username",
    //                     style: TextStyle(fontSize: 20),
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               TextFormField(
    //                 autofocus: false,
    //                 enabled: false,
    //                 initialValue: 'ricardo_milos',
    //                 decoration: InputDecoration(
    //                   filled: true,
    //                   fillColor: Color(0xffeeeeee),
    //                   contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    //                   border: OutlineInputBorder(
    //                       borderRadius: BorderRadius.circular(16.0)),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 children: <Widget>[
    //                   Text(
    //                     "Email",
    //                     style: TextStyle(fontSize: 20),
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               TextFormField(
    //                 enabled: false,
    //                 autofocus: false,
    //                 initialValue: 'ricardo_milos@gmail.com',
    //                 decoration: InputDecoration(
    //                   filled: true,
    //                   fillColor: Color(0xffeeeeee),
    //                   contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    //                   border: OutlineInputBorder(
    //                       borderRadius: BorderRadius.circular(16.0)),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           //  SizedBox(height: 70,),
    //           Column(
    //             children: <Widget>[
    //               _renderButtons(),
    //             ],
    //           ),
    //         ],
    //       ),
    //   ),
    // ));
    return (Expanded(
      // height: double.infinity,
      child: Container(
        padding: EdgeInsets.all(20),
        // mainAxisSize: MainAxisSize.max,
        // shrinkWrap: true,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Hồ sơ của bạn",
                          style:
                              TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      flex: 1,
                      child: Stack(
                        // color: Colors.white,
                        // child: CircleAvatar(
                        //   // radius: 40,
                        //   minRadius: 40.0,
                        //   maxRadius: 80.0,
                        //   backgroundImage: NetworkImage("https://www.kragelj.com/wp-content/uploads/2016/11/dummy-profile-pic1.png"),
                        // ),
                        children: _isEditingProfile
                        ? <Widget>[
                          InkWell(
                            onTap: () { print('tap'); },
                            // borderRadius: BorderRadius.circular(100.0),
                            child: ClipOval(
                              child: Image.network(
                                currentUser.profilePicture,
                                // width: 100,
                                // height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.blue, width: 1.8),
                                borderRadius: BorderRadius.circular(100)
                              ),
                              child: Icon(Icons.edit, color: Colors.blue,),
                            ),
                          )
                        ]
                        : <Widget>[
                          ClipOval(
                            child: Image.network(
                              currentUser.profilePicture,
                              // width: 100,
                              // height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ]
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Tên",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff666666)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autofocus: false,
                    enabled: false,
                    initialValue: currentUser.displayName,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffeeeeee),
                      contentPadding: EdgeInsets.fromLTRB(14.0, 10.0, 14.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Username",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff666666)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autofocus: false,
                    enabled: false,
                    initialValue: currentUser.displayName,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffeeeeee),
                      contentPadding: EdgeInsets.fromLTRB(14.0, 10.0, 14.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Email",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff666666)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    enabled: false,
                    autofocus: false,
                    initialValue: currentUser.email,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffeeeeee),
                      contentPadding: EdgeInsets.fromLTRB(14.0, 10.0, 14.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 30,),
                  _renderButtons(),
                ],
              ),
            ],
          ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Column(
        children: <Widget>[_renderHeader(), _renderBody()],
      ),
    );
  }
}
