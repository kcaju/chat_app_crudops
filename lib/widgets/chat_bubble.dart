import 'package:chat_app/utils/color_constants.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key, required this.isCurrentUser, required this.message});
  final bool isCurrentUser;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isCurrentUser ? ColorConstants.yellow : ColorConstants.blue,
      ),
      child: Text(
        message,
        style: TextStyle(
            color: ColorConstants.black,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
