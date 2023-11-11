// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
// import 'dart:io';

import 'package:chat_app/constants/const.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/services.dart' show rootBundle;

import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../helpers.dart';

// import 'package:mime/mime.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

class ChatScreenPage extends StatefulWidget {
  const ChatScreenPage({
    super.key,
    required this.username,
    required this.imageLink,
    required this.userTag,
    required this.userTag_name,
    required this.conversation,
    required this.receiver_id,
  });
  final username;
  final imageLink;
  final userTag;
  final userTag_name;
  final conversation;
  final receiver_id;

  @override
  State<ChatScreenPage> createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  final Duration reconnectDelay = const Duration(seconds: 5);
  StreamSubscription<dynamic>? subscription;
  List<types.Message> _messages = [];
  dynamic _user = const types.User(
    id: '',
  );
  bool isLoading = true;
  WebSocketChannel? channel;
  IO.Socket? socket;
  String? userId;

  @override
  void initState() {
    getUserid();
    connectToServer();
    super.initState();
  }

  void getUserid() async {
    dynamic userId = await getUserData();
    String id = userId["id"];

    setState(() {
      userId = id;
      _user = types.User(
        id: id,
      );
      isLoading = false;
    });

    getAllMessages(id);
  }

  void getAllMessages(id) {
    if (widget.conversation.isNotEmpty) {
      for (dynamic discussion in widget.conversation) {
        final textMessage = types.TextMessage(
          author: types.User(
            id: id,
          ),
          createdAt: int.parse(discussion["createdAt"]),
          id: discussion["id"],
          text: discussion["content"],
        );
        print(textMessage);

        _addMessage(textMessage);
      }
    }
  }

  void connectToServer() {
    setState(() {
      socket = IO.io(dotenv.env['WEBSOCKET'].toString(), <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });
    });

    debugPrint('Socket URL: ${socket?.io.uri.toString()}');

    socket?.connect();
    debugPrint(socket?.connected.toString());

    socket?.onConnect((data) {
      debugPrint("Connected");
      socket!.emit(
          "info",
          json.encode({
            "user_id": _user,
          }));
    });

    socket?.on('message', (message) {
      try {
        var messageReceive = json.decode(message);
        print(messageReceive);
        // if (messageReceive["type"] == "Message") {
        //   final textMessage = types.TextMessage(
        //     author: types.User(
        //       id: messageReceive["data"]["author"]["id"],
        //     ),
        //     createdAt: messageReceive["data"]["createdAt"],
        //     id: messageReceive["data"]["id"],
        //     text: messageReceive["data"]["text"],
        //   );

        //   _addMessage(textMessage);
        // }
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    socket?.onDisconnect((_) {
      debugPrint('Disconnected from server');
    });

    socket?.onError((error) {
      debugPrint('Socket connection error: $error');
      connectToServer();
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    dynamic messageToSend = {
      "type": "Message",
      "data": {
        "author": _user,
        "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
        "id": const Uuid().v4(),
        "text": message.text,
      },
      "receiverId": widget.receiver_id,
    };

    sendMessage(messageToSend);
    _addMessage(textMessage);
  }

  Future<void> sendMessage(data) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var body = json.encode(data);

    await http.post(
      Uri.parse('${dotenv.env['BASE_URL']}chats/send'),
      headers: headers,
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 149, 243),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            );
          },
        ),
        centerTitle: false,
        title: Hero(
          tag: widget.userTag_name,
          child: Text(
            widget.username,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Hero(
            tag: widget.userTag,
            child: CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                widget.imageLink,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: isLoading
          ? loader
          : Chat(
              messages: _messages,
              // onAttachmentPressed: _handleAttachmentPressed,
              // onMessageTap: _handleMessageTap,
              // onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              user: _user,
            ),
    );
  }
}
