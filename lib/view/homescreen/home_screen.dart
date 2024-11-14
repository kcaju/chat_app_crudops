import 'package:chat_app/controller/auth_services.dart';
import 'package:chat_app/controller/chat/chat_controller.dart';
import 'package:chat_app/utils/color_constants.dart';
import 'package:chat_app/utils/image_constants.dart';
import 'package:chat_app/view/chatpage/chat_page.dart';
import 'package:chat_app/widgets/mydrawer.dart';
import 'package:chat_app/widgets/user_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final ChatController chatController = ChatController();
  final AuthServices authcontroller = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.blue,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: ColorConstants.black,
              )),
        ),
        title: Text(
          'Home Screen',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ColorConstants.black),
        ),
      ),
      drawer: Mydrawer(),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(ImageConstants.home))),
          child: _buildUserList()),
    );
  }

//build list of users
  Widget _buildUserList() {
    return StreamBuilder(
      stream: chatController.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          padding: EdgeInsets.all(10),
          children: snapshot.data!
              .map<Widget>(
                (userData) => _buildUserListItem(userData, context),
              )
              .toList(),
        );
      },
    );
  }

//build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != authcontroller.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: userData['email'],
                  receiverID: userData['uid'],
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
