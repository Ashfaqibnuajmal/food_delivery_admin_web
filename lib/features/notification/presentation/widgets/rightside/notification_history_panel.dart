import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/notification/data/model/notification_model.dart';
import 'package:user_app/features/notification/presentation/widgets/rightside/notification_history_header.dart';
import 'package:user_app/features/notification/presentation/widgets/rightside/notification_item.dart';
import 'package:user_app/features/notification/provider/notification_provider.dart';

class NotificationHistoryPanel extends StatelessWidget {
  final NotificationProvider provider;
  final Function(BuildContext, String) onDelete;

  const NotificationHistoryPanel({
    super.key,
    required this.provider,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1000;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationHistoryHeader(provider: provider),

          const SizedBox(height: 20),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: provider.getNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.lightBlue,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: CustomTextStyles.mediumWhiteText,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_rounded,
                            size: isMobile ? 50 : 60,
                            color: AppColors.pureWhite,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            'No notifications sent yet',
                            textAlign: TextAlign.center,
                            style: CustomTextStyles.mediumWhiteText,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];

                        final notification = NotificationModel.fromMap(
                          doc.data() as Map<String, dynamic>,
                          doc.id,
                        );

                        return Container(
                          width: constraints.maxWidth,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 14 : 20,
                            vertical: isMobile ? 14 : 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.deepBlue,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.mediumBlue.withOpacity(0.3),
                            ),
                          ),
                          child: NotificationItem(
                            notification: notification,
                            onDelete: () => onDelete(context, doc.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
