import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat/widgets/chat_messge.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  final List<ChatMessage> _messages = [];

  bool _writing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: const Text(
                'Us',
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            const SizedBox(height: 3),
            const Text(
              'User Test',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),
            const Divider(height: 1),
            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            // TextField
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (text) {
                  setState(() {
                    if (text.trim().isNotEmpty) {
                      _writing = true;
                    } else {
                      _writing = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),
            // Botón de enviar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.send),
                    onPressed: _writing
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uuid: '123',
      text: text,
      animationController: AnimationController(
          vsync: this, duration: const Duration(microseconds: 400)),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _writing = false;
    });
  }

  @override
  void dispose() {
    // TODO: Off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}
