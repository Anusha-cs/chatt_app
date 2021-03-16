import 'package:chatt_app/helper/authenticate.dart';
import 'package:chatt_app/helper/constants.dart';
import 'package:chatt_app/helper/helperfunctions.dart';
import 'package:chatt_app/helper/theme.dart';
import 'package:chatt_app/services/auth.dart';
import 'package:chatt_app/services/database.dart';
import 'package:chatt_app/views/chat.dart';
import 'package:chatt_app/views/search.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 100,
          width: 200,
          alignment: Alignment(-4.0, 0),
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Color(0xffDE3163),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  userName.substring(0, 1),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              userName,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w500),
            ),
            Spacer(),
            RaisedButton.icon(
              onPressed: () {
                print('Button Clicked.');
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
              label: Text(
                'Locate',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w800),
              ),
              padding: EdgeInsets.only(
                right: 10,
              ),
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              textColor: Colors.white,
              splashColor: Colors.pink[600],
              color: Color(0xff34626B),
            ),
          ],
        ),
      ),
    );
  }
}
