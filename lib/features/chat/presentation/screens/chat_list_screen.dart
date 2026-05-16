import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/features/chat/data/services/chat_services.dart';
import 'package:user_app/features/chat/logic/controller/chat_controller.dart';
import 'package:user_app/features/chat/presentation/widgets/chat_list/chat_left_panel.dart';
import 'package:user_app/features/chat/presentation/widgets/chat_window/chat_right_panel.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final ChatController chatController;

  @override
  void initState() {
    super.initState();
    chatController = ChatController();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatService = context.read<ChatServices>();

    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(12), // ← OLD DISTANCE BACK
      child: Row(
        children: [
          SizedBox(
            width: width < 1100 ? 300 : 320,
            child: ChatLeftPanel(
              chatService: chatService,
              utils: chatController,
            ),
          ),

          const SizedBox(width: 12), // ← SPACE BETWEEN LEFT & RIGHT

          Expanded(child: ChatRightPanel(controller: chatController)),
        ],
      ),
    );
  }
}
