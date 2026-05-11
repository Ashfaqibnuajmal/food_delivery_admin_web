import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/features/chat/data/services/chat_services.dart';
import 'package:user_app/features/chat/logic/controller/chat_controller.dart';
import 'package:user_app/features/chat/presentation/widgets/chat_list/left_panel.dart';
import 'package:user_app/features/chat/presentation/widgets/chat_list/right_panel.dart';

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
  @override
  Widget build(BuildContext context) {
    final chatService = context.read<ChatServices>();

    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280, maxWidth: 380),
          child: ChatLeftPanel(chatService: chatService, utils: chatController),
        ),

        Expanded(child: ChatRightPanel(controller: chatController)),
      ],
    );
  }
}
