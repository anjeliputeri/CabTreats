import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'chat_screen.dart';


class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        stream: _combineMessageStreams(user?.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chats available.'));
          }

          final messages = snapshot.data!;

          // Create a map to hold the latest message for each chat
          final Map<String, Map<String, dynamic>> chatMap = {};

          for (var message in messages) {
            var messageData = message.data();
            var chatKey = messageData['senderEmail'] + '-' + messageData['receiverEmail'];

            // Store the latest message in the map
            chatMap[chatKey] = messageData;
          }

          // Extract unique chats for the current user
          final List<Map<String, dynamic>> chatList = [];
          final Set<String> seenEmails = {};

          for (var messageData in chatMap.values) {
            final senderEmail = messageData['senderEmail'];
            final receiverEmail = messageData['receiverEmail'];

            // Determine the chat partner's email
            final otherPartyEmail = (senderEmail == user?.email) ? receiverEmail : senderEmail;

            if (!seenEmails.contains(otherPartyEmail)) {
              seenEmails.add(otherPartyEmail);
              chatList.add(messageData);
            }
          }

          return ListView.builder(
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              final messageData = chatList[index];
              final otherPartyEmail = (messageData['senderEmail'] == user?.email)
                  ? messageData['receiverEmail']
                  : messageData['senderEmail'];
              final otherPartyName = (messageData['senderEmail'] == user?.email)
                  ? messageData['receiverName']
                  : messageData['senderName'];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(otherPartyName[0]),
                ),
                title: Text(otherPartyName),
                subtitle: Text(messageData['text']),
                trailing: Icon(Icons.message),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        email: otherPartyEmail,
                        name: otherPartyName,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _combineMessageStreams(String? userEmail) {
    if (userEmail == null) {
      return Stream.value([]);
    }

    final senderStream = _firestore.collection('messages')
        .where('senderEmail', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs);

    final receiverStream = _firestore.collection('messages')
        .where('receiverEmail', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs);

    return Rx.combineLatest2(senderStream, receiverStream, (List<QueryDocumentSnapshot<Map<String, dynamic>>> senderDocs,
        List<QueryDocumentSnapshot<Map<String, dynamic>>> receiverDocs) {
      return [...senderDocs, ...receiverDocs];
    });
  }
}
