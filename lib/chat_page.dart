import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linkedin_learning/models/chat_message_entity.dart';
import 'package:linkedin_learning/models/image_model.dart';
import 'package:linkedin_learning/repo/image_repository.dart';
import 'package:linkedin_learning/services/auth_service.dart';
import 'package:linkedin_learning/widgets/chat_bubble.dart';
import 'package:linkedin_learning/widgets/chat_input.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //initiate state of messages
  List<ChatMessageEntity> _messages = [];

  _loadInitialMessages() async {
    rootBundle
        .loadString(
            '/Users/davidshim/StudioProjects/Linkedin_Learning/assets/mock_messages.json')
        .then((response) {
      final List<dynamic> decodedList = jsonDecode(response) as List;

      final List<ChatMessageEntity> _chatMessages = decodedList.map((listItem) {
        return ChatMessageEntity.fromJson(listItem);
      }).toList();

      print(_chatMessages.length);

      //final state of the messages
      setState(() {
        _messages = _chatMessages;
      });
    }).then((_) {
      print('done!');
    });
  }

  onMessageSent(ChatMessageEntity entity) {
    _messages.add(entity);
    setState(() {});
  }

  @override
  void initState() {
    _loadInitialMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AuthService>().getUsername();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Hi $username!'),
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthService>().updateUserName("New Name!");
              },
              icon: Icon(Icons.change_circle)),
          IconButton(
              onPressed: () {
                context.read<AuthService>().logoutUser();
                Navigator.pushReplacementNamed(context, '/');
                print('Icon pressed!');
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                        alignment: _messages[index].author.userName ==
                                context.read<AuthService>().getUsername()
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        entity: _messages[index]);
                  })),
          ChatInput(
            onSubmit: onMessageSent,
          ),
        ],
      ),
    );
  }
}
