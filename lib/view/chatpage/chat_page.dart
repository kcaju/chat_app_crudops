import 'package:chat_app/controller/auth_services.dart';
import 'package:chat_app/controller/chat/chat_controller.dart';
import 'package:chat_app/utils/color_constants.dart';
import 'package:chat_app/utils/image_constants.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.receiverEmail, required this.receiverID});
  final String receiverEmail, receiverID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController message = TextEditingController();

  final ChatController chatController = ChatController();

  final AuthServices authcontroller = AuthServices();
  //for textfield focus

  FocusNode focus = FocusNode();

  Future<void> sendMessage() async {
    if (message.text.isNotEmpty) {
      await chatController.sendMessage(widget.receiverID, message.text);
      message.clear();
    }
    scrollDown();
  }

  @override
  void initState() {
    focus.addListener(
      () {
        if (focus.hasFocus) {
          Future.delayed(Duration(microseconds: 500), () => scrollDown());
        }
      },
    );
    Future.delayed(Duration(microseconds: 500), () => scrollDown());

    super.initState();
  }

  final ScrollController scrollController = ScrollController();
  void scrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.blueGrey,
        title: Text(
          widget.receiverEmail,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(ImageConstants.screen))),
        child: Column(
          children: [Expanded(child: _buildMessagesList()), buildUserInput()],
        ),
      ),
    );
  }

  //build message list
  Widget _buildMessagesList() {
    String senderID = authcontroller.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: chatController.getMessages(widget.receiverID, senderID),
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
          controller: scrollController,
          children: snapshot.data!.docs
              .map(
                (doc) => _buildMessageItem(doc),
              )
              .toList(),
        );
      },
    );
  }

  //build msg item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    //if current user
    bool isCurrentUser =
        data['senderID'] == authcontroller.getCurrentUser()!.uid;

    //align message
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(isCurrentUser: isCurrentUser, message: data['message']),
          ],
        ));
  }

  //build user input
  Widget buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: message,
              focusNode: focus,
              style: TextStyle(color: ColorConstants.white, fontSize: 20),
              obscureText: false,
              decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle:
                      TextStyle(color: ColorConstants.white, fontSize: 18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
          )),
          Container(
              margin: EdgeInsets.only(right: 25),
              decoration: BoxDecoration(
                color: ColorConstants.green1,
                shape: BoxShape.circle,
              ),
              child: IconButton(onPressed: sendMessage, icon: Icon(Icons.send)))
        ],
      ),
    );
  }
}
