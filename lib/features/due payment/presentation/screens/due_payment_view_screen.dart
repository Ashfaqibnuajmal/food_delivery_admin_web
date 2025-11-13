import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/due%20payment/data/services/due_payment_services.dart';
import 'package:user_app/features/due%20payment/presentation/widget/due_details_screen/due_details_card.dart';
import 'package:user_app/features/due%20payment/presentation/widget/due_details_screen/due_details_header.dart';

class DuePaymentViewScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const DuePaymentViewScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final service = DuePaymentService();

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              DueDetailsHeader(userId: userId, userName: userName),
              const SizedBox(height: 20),
              UserEntriesCard(
                userId: userId,
                userName: userName,
                service: service,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
