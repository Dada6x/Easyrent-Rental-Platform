import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:uuid/uuid.dart';
import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';

class Ai_ChatBot extends StatefulWidget {
  const Ai_ChatBot({super.key});

  @override
  State<Ai_ChatBot> createState() => _ChatPageState();
}

class _ChatPageState extends State<Ai_ChatBot> {
  final messageController = TextEditingController();
  final List<types.Message> _messages = [];

  // 👤 User who sends messages
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  // 🤖 AI bot user
  final _bot = const types.User(
    id: 'ai-bot-id',
    imageUrl: avatar2,
    firstName: 'AI Bot',
  );

  // 📡 Hugging Face model and token
  final String _apiKey = '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';
  final String _model = 'HuggingFaceH4/zephyr-7b-beta';

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<String> _sendMessageToHuggingFace(String input) async {
    try {
      final response = await _dio.post(
        'https://api-inference.huggingface.co/models/$_model',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "inputs": input,
        },
      );

      final generatedText = response.data[0]['generated_text'];
      return generatedText;
    } catch (e) {
      print('AI Error: $e');
      return 'Sorry, something went wrong.';
    }
  }

  void _handleSendPressed(types.PartialText message) async {
    final userMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(userMessage);

    // 2. Show typing placeholder (optional)
    final typingMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: '...',
    );
    _addMessage(typingMessage);

    // 3. Get AI response
    final botReply = await _sendMessageToHuggingFace(message.text);

    // 4. Remove the '...' message
    setState(() {
      _messages.remove(typingMessage);
    });

    // 5. Add real AI reply
    final botMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: botReply,
    );
    _addMessage(botMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_messages.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 90,
                  child: Iconify(
                    Ph.robot_thin,
                    size: 80,
                    color: white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "AI Agent",
                    style: AppTextStyles.h32medium,
                  ),
                )
              ],
            ),
          ),
       
      ],
    );
  }
}

