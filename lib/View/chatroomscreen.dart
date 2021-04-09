import 'package:chat_app/Helper/authenticate.dart';
import 'package:chat_app/Helper/constants.dart';
import 'package:chat_app/Helper/helperfunctions.dart';
import 'package:chat_app/Services/auth.dart';
import 'package:chat_app/Services/database.dart';
import 'package:chat_app/View/SearchScreen.dart';
import 'package:chat_app/View/conversationscreen.dart';
import 'package:chat_app/Widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStreams;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStreams,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                      userName: snapshot.data.docs[index]
                          .data()['chatRoomID']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      chatRoomId:
                          snapshot.data.docs[index].data()["chatRoomID"]);
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStreams = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              authMethod.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
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
            builder: (context) => ConversationScreen(chatRoomId),
          ),
        );
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(userName.substring(0, 2),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 20,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              width: 24,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}
