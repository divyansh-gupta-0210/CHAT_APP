import 'package:chat_app/Helper/constants.dart';
import 'package:chat_app/Helper/helperfunctions.dart';
import 'package:chat_app/Services/database.dart';
import 'package:chat_app/View/conversationscreen.dart';
import 'package:chat_app/Widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController =
      new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchResultSnapshot;

  Widget searchList() {
    return searchResultSnapshot != null
        ? ListView.builder(
            itemCount: searchResultSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchResultSnapshot.docs[index].data()["name"],
                userEmail: searchResultSnapshot.docs[index].data()["email"],
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchResultSnapshot = val;
      });
    });
  }

  createChatRoomAndStartConvo({String userName}) {
    print("${Constants.myName}");
    if (userName != Constants.myName) {

      String chatRoomId = getChatRoomId(Constants.myName, userName);

      List<String> users = [Constants.myName, userName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomID": chatRoomId
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("You cannot send message yourself!");
    }
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: mediumTextStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConvo(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Message",
                style: mediumTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
    print("$_myName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        padding: EdgeInsets.only(top: 8, right: 3, left: 3),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.indigoAccent, Colors.purpleAccent],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Search Username",
                          hintStyle:
                              TextStyle(color: Colors.white54, fontSize: 19),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    // color: Colors.blueAccent,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.indigoAccent, Colors.purpleAccent],
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        initiateSearch();
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      iconSize: 28,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
