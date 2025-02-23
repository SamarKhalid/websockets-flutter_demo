import 'package:flutter/material.dart';
import 'package:websockets_demo/websocket_config.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  late WebSocketConfig websocket;

  @override
  void initState() {
    super.initState();
    websocket = WebSocketConfig(serverUrl: 'wss://ws.ifelse.io');

    websocket.connect(
          (message) {
        setState(() {
          _messages.add("Server: $message"); // Add server messages to chat
        });
      },
          (error) {
        setState(() {
          _messages.add(error); // Display errors
        });
      },
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      String message = _messageController.text.trim();

      websocket.sendMessage(message); // Send message via WebSocket

      setState(() {
        _messages.add("You: $message"); // Show sent message in chat
      });

      _messageController.clear();
    }
  }

  @override
  void dispose() {
    websocket.closeConnection(); // Close WebSocket on screen exit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebSocket Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUserMessage = _messages[index].startsWith("You:");
                return Align(
                  alignment:
                  isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      _messages[index],
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
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
