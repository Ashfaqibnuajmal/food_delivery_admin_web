import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/notification/core/utils/responsive_helper_function.dart';
import 'package:user_app/features/notification/presentation/widgets/leftside/notification_message_field.dart';
import 'package:user_app/features/notification/presentation/widgets/leftside/notification_title_field.dart';
import 'package:user_app/features/notification/presentation/widgets/leftside/send_notification_button.dart';
import 'package:user_app/features/notification/presentation/widgets/leftside/send_notification_header.dart';
import 'package:user_app/features/notification/provider/notification_provider.dart';

class SendNotificationPanel extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController messageController;
  final NotificationProvider provider;

  const SendNotificationPanel({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.messageController,
    required this.provider,
  });

  @override
  State<SendNotificationPanel> createState() => _SendNotificationPanelState();
}

class _SendNotificationPanelState extends State<SendNotificationPanel> {
  @override
  void initState() {
    super.initState();
    widget.provider.addListener(_onProviderChange);
  }

  void _onProviderChange() {
    if (widget.provider.isSent) {
      widget.titleController.clear();
      widget.messageController.clear();
      widget.formKey.currentState?.reset();

      widget.provider.resetState();
    }
  }

  @override
  void dispose() {
    widget.provider.removeListener(_onProviderChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return SizedBox(
      width: isMobile ? double.infinity : 420,
      child: Container(
        color: AppColors.deepBlue,
        padding: EdgeInsets.all(isMobile ? 18 : 32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SendNotificationHeader(),

                SizedBox(height: isMobile ? 20 : 28),

                Divider(color: AppColors.mediumBlue.withOpacity(0.3)),

                SizedBox(height: isMobile ? 20 : 28),

                NotificationTitleField(controller: widget.titleController),

                const SizedBox(height: 20),

                NotificationMessageField(controller: widget.messageController),

                const SizedBox(height: 24),

                SendNotificationButton(
                  isLoading: widget.provider.isLoading,
                  formKey: widget.formKey,
                  titleController: widget.titleController,
                  messageController: widget.messageController,
                  provider: widget.provider,
                ),

                SizedBox(height: isMobile ? 10 : 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
