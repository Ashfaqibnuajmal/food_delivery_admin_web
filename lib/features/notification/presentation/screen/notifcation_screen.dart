import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/notification/presentation/widgets/leftside/send_notification_panel.dart';
import 'package:user_app/features/notification/presentation/widgets/rightside/delete_notification_dialog.dart';
import 'package:user_app/features/notification/presentation/widgets/rightside/notification_history_panel.dart';
import 'package:user_app/features/notification/provider/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late TextEditingController _titleController;
  late TextEditingController _messageController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  void _showDeleteDialog(BuildContext context, String docId) {
    final provider = context.read<NotificationProvider>();

    showDialog(
      context: context,
      builder: (_) =>
          DeleteNotificationDialog(docId: docId, provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 1000;

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            return isMobile
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        SendNotificationPanel(
                          formKey: _formKey,
                          titleController: _titleController,
                          messageController: _messageController,
                          provider: provider,
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: NotificationHistoryPanel(
                            provider: provider,
                            onDelete: _showDeleteDialog,
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SendNotificationPanel(
                        formKey: _formKey,
                        titleController: _titleController,
                        messageController: _messageController,
                        provider: provider,
                      ),

                      Expanded(
                        child: NotificationHistoryPanel(
                          provider: provider,
                          onDelete: _showDeleteDialog,
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
