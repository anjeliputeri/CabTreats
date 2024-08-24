import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String email;
  final String name;

  const ChatScreen({Key? key, required this.email, required this.name}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? senderName;

  @override
  void initState() {
    super.initState();
    _getSenderName();
  }

  // Fungsi untuk mengambil nama pengirim berdasarkan email
  Future<void> _getSenderName() async {
    final user = _auth.currentUser;
    if (user != null) {
      final querySnapshot = await _firestore.collection('users')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        setState(() {
          senderName = userData['name'];
        });
      } else {
        setState(() {
          senderName = 'Anonymous';
        });
      }
    }
  }

  void _sendMessage() async {
    final user = _auth.currentUser;

    if (_messageController.text.isNotEmpty && user != null) {
      await _firestore.collection('messages').add({
        'text': _messageController.text,
        'createdAt': Timestamp.now(),
        'senderEmail': user.email,
        'senderName': senderName ?? 'Anonymous',
        'receiverEmail': widget.email,
        'receiverName': widget.name,
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('Tidak ada pesan.'),
                  );
                }

                final currentUserEmail = _auth.currentUser?.email;
                final messages = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return (data['senderEmail'] == currentUserEmail && data['receiverEmail'] == widget.email) ||
                      (data['senderEmail'] == widget.email && data['receiverEmail'] == currentUserEmail);
                }).toList();

                if (messages.isEmpty) {
                  return Center(child: Text('Tidak ada pesan.'));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData = messages[index].data() as Map<String, dynamic>;
                    var isMe = messageData['senderEmail'] == _auth.currentUser?.email;
                    return ListTile(
                      title: Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blueAccent : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            messageData['text'],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      subtitle: Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          isMe ? 'You' : messageData['senderName'],
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Send a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
