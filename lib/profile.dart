import 'dart:io';
import 'package:bilinguo_flutter/mock-data.dart';
import 'package:bilinguo_flutter/utils/HexColor.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
// import './mock-data.dart';
import 'package:bilinguo_flutter/models/AppState.dart';
import './models/User.dart';
import 'package:redux/redux.dart';

class ProfileScreen extends StatefulWidget {
  final ViewModel viewModel;

  ProfileScreen(this.viewModel);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditingProfile = false;
  File _image;
  // String _uploadedFileURL;
  bool _isUpdatingUserInfo = false;
  User _currentUser;

  @override
  void initState() {
    super.initState();
    print(widget.viewModel);
    _currentUser = widget.viewModel.currentUser;
  }

  Future uploadFile() async {
    setState(() {
      _isUpdatingUserInfo = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profiles/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      User newUserInfo = User(
        profilePicture: fileURL,
      );
      User.updateUserProfile(_currentUser.token, newUserInfo)
      .then((updatedUser) {
        // var oldImg = widget.viewModel.currentUser.profilePicture;
        print(updatedUser.profilePicture);
        print(widget.viewModel.currentUser.profilePicture);
        widget.viewModel.onSetCurrentUser(updatedUser);
        print(widget.viewModel.currentUser.profilePicture);
        // while(oldImg == widget.viewModel.currentUser.profilePicture) {
        //   Future.delayed(const Duration(milliseconds: 500), () {});
        // }
        setState(() {
          // _uploadedFileURL = fileURL;
          // _currentUser = updatedUser;
          _currentUser = widget.viewModel.currentUser;
          _isUpdatingUserInfo = false;
        });
      })
      .catchError((err) {
        print(err);
      });
    });
  }

  void _showUploadFileModal() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (context) {
        // return object of type Dialog
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            Future chooseFile() async {
              await ImagePicker.pickImage(source: ImageSource.gallery)
                  .then((image) {
                print(image);
                print(image.path);
                setModalState(() {
                  _image = image;
                });
                setState(() {
                  _image = image;
                });
              });
            }

            clearSelection() {
              setModalState(() {
                _image = null;
                // _uploadedFileURL = null;
              });
              setState(() {
                _image = null;
                // _uploadedFileURL = null;
              });
            }

            return AlertDialog(
              title: Text(
                "Chọn bức ảnh đẹp nhất của bạn để làm ảnh đại diện",
                style: TextStyle(
                    fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              // content: Text('Bạn có muốn mua "' + item.name + '" với giá ' + item.price.toString() + ' lingots?'),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Ảnh đã chọn',
                      style: TextStyle(
                          fontFamily: 'Quicksand', fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.0),
                    _image != null
                        // ? Image.asset(
                        //     _image.path,
                        //     height: 150,
                        //   )
                        ? ClipOval(
                            child: Image.file(
                              _image,
                              // width: 100,
                              // height: 100,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(
                            child: Image.asset(
                              'assets/no-photo.png',
                              // width: 100,
                              // height: 100,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                    SizedBox(height: 20.0),
                    _image == null
                        ? RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Container(
                              width: 80.0,
                              child: Center(
                                child: Text('Chọn file'.toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                            onPressed: chooseFile,
                            color: Color(0xff1CB0F6),
                          )
                        : Container(),
                    _image != null
                        ? RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Container(
                              width: 80.0,
                              child: Center(
                                child: Text('Upload'.toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              uploadFile();
                            },
                            color: Color(0xff1CB0F6),
                          )
                        : Container(),
                    _image != null
                        ? RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Container(
                              width: 80.0,
                              child: Center(
                                child: Text('Bỏ chọn'.toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                            onPressed: () {
                              clearSelection();
                            },
                            color: Color(0xffbbbbbb),
                          )
                        : Container(),
                    // Text('Uploaded Image'),
                    // _uploadedFileURL != null
                    //     ? Image.network(
                    //         _uploadedFileURL,
                    //         height: 150,
                    //       )
                    //     : Container(),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: new Text(
                    "Đóng".toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

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
                  !_isEditingProfile
                      ? _handleEditingTap()
                      : _handleFinishEditingTap();
                },
                padding: EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 14.0),
                elevation: 4,
                color: Colors.white,
                child: Text(
                    (!_isEditingProfile ? 'Chỉnh sửa' : 'Hoàn tất')
                        .toUpperCase(),
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
    return (Expanded(
      // height: double.infinity,
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            // mainAxisSize: MainAxisSize.max,
            // shrinkWrap: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  // flex: 1,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Hồ sơ của bạn",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // flex: 1,
                        // color: Colors.red,
                        height: 146,
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
                                      onTap: () {
                                        _showUploadFileModal();
                                      },
                                      borderRadius: BorderRadius.circular(100.0),
                                      // child: ClipOval(
                                      //   child: Image.network(
                                      //     _currentUser.profilePicture,
                                      //     // width: 100,
                                      //     // height: 100,
                                      //     fit: BoxFit.cover,
                                      //   ),
                                      // ),
                                      // child: Container(
                                      //   width: 150,
                                      //   height: 150,
                                      //   child: ClipOval(
                                      //   child: Image.network(
                                      //     _currentUser.profilePicture,
                                      //     fit: BoxFit.contain,
                                      //     // width: 90.0,
                                      //     // height: 90.0,
                                      //   )
                                      // ),
                                      // ),
                                      child: AspectRatio(
                                        // width: 120,
                                        // height: 120,
                                        aspectRatio: 1 / 1,
                                        child: CircleAvatar(
                                          minRadius: 10,
                                          maxRadius: 70,
                                          backgroundImage:
                                              NetworkImage(_currentUser.profilePicture),
                                          backgroundColor: Colors.transparent,
                                        )
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.blue, width: 1.8),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )
                                  ]
                                : <Widget>[
                                    // ClipOval(
                                    //   child: Image.network(
                                    //     _currentUser.profilePicture,
                                    //     // width: 100,
                                    //     // height: 100,
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // ),
                                    AspectRatio(
                                        // width: 120,
                                        // height: 120,
                                        aspectRatio: 1 / 1,
                                        child: CircleAvatar(
                                          minRadius: 10,
                                          maxRadius: 70,
                                          backgroundImage:
                                              NetworkImage(_currentUser.profilePicture),
                                          backgroundColor: Colors.transparent,
                                        )
                                      ),
                                  ]),
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
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autofocus: false,
                      enabled: false,
                      initialValue: _currentUser.displayName,
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
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autofocus: false,
                      enabled: false,
                      initialValue: _currentUser.displayName,
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
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      enabled: false,
                      autofocus: false,
                      initialValue: _currentUser.email,
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
                    SizedBox(
                      height: 30,
                    ),
                    _renderButtons(),
                  ],
                ),
              ],
            ),
          ),
          if (_isUpdatingUserInfo) (
            Stack(
              children: <Widget>[
                Opacity(
                  opacity: 0.6,
                  child: ModalBarrier(dismissible: false, color: Colors.white),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
          ),
        ],
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
    // return StoreConnector(
    //   converter: (Store<AppState> store) => ViewModel.create(store),
    //   builder: (context, ViewModel viewModel) => Container(
    //     // color: Colors.red,
    //     child: Column(
    //       children: <Widget>[_renderHeader(), _renderBody()],
    //     ),
    //   ),
    // );
  }
}
