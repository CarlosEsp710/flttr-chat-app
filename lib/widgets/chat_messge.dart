import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uuid;
  final AnimationController animationController;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.uuid,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uuid == '123' ? _myMessage() : _yourMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          bottom: 5,
          right: 5,
          left: 50,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
          color: const Color(0XFF4D9EF6),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _yourMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          bottom: 5,
          left: 5,
          right: 50,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black87),
        ),
        decoration: BoxDecoration(
          color: const Color(0XFFE4E5E8),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
