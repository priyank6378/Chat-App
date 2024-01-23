import 'package:chat_app/service/crud/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatPageView extends StatefulWidget {
  const ChatPageView({super.key});

  @override
  State<ChatPageView> createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<ChatPageView> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final user = args["user"];
    final otherUser = args["otherUser"];

    TextEditingController _messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(otherUser["userName"] ?? "UNKNOWN"),
        centerTitle: true,
      ),
      body: chatsWidget(user, otherUser),
      bottomSheet: Container(
        height: 60,
        width: double.infinity,
        color: Colors.grey[200],
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                String message = _messageController.text;

                // SEND MESSAGE
                FirestoreService().sendMessage(
                  message,
                  user!.uid,
                  otherUser!["uid"],
                );

                // CLEAR TEXT FIELD
                _messageController.clear();
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  // chats widget to show the chats between two users
  Widget chatsWidget(dynamic user, dynamic otherUser) {
    // all messages
    final allMessages = FirestoreService().getMessages(
      user!.uid,
      otherUser!["uid"],
    );

    return StreamBuilder(
      stream: allMessages,
      builder: (contex, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data;
          return ListView.builder(
            itemCount: messages?.docs.length,
            itemBuilder: (context, index) {
              final message = messages?.docs[index];
              return Container(
                width: 100,
                alignment: message!["sender"] == user.uid
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                decoration: BoxDecoration(
                  color: message["sender"] == user.uid
                      ? Colors.blue[100]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(message["message"]),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
