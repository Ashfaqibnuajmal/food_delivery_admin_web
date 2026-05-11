import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/user_search_provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_table_header.dart';
import 'package:user_app/features/users/controller/user_controller.dart';
import 'package:user_app/features/users/data/model/user_model.dart';
import 'package:user_app/features/users/presentation/widget/data_cell_text.dart';

class UserTable extends StatelessWidget {
  const UserTable({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserSearchProvider>();
    final users = provider.filteredUsers;

    if (users.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('No users found', style: CustomTextStyles.text),
        ),
      );
    }

    return const Expanded(child: _UserTableBody());
  }
}

class _UserTableBody extends StatelessWidget {
  const _UserTableBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserSearchProvider>();
    final filtered = provider.filteredUsers;

    return Container(
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.lightBlue.withOpacity(0.1),
        border: Border.all(color: AppColors.deepBlue, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          // Header Row
          Container(
            height: 50,
            decoration: const BoxDecoration(
              color: AppColors.deepBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: const Row(
              children: [
                HeaderCell(title: 'Name'),
                HeaderCell(title: 'Phone No'),
                HeaderCell(title: 'Email'),
                HeaderCell(title: 'Status'),
                HeaderCell(title: 'Action'),
              ],
            ),
          ),

          // Filtered data rows
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final user = filtered[i];
                return UserTableRow(user: user);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Each row UI only, logic-free
class UserTableRow extends StatelessWidget {
  final UserModel user;
  const UserTableRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isActive = user.status.toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          DataCellText(user.name.isEmpty ? "No name" : user.name),
          DataCellText(user.phone.isEmpty ? "No number" : user.phone),
          DataCellText(user.email.isEmpty ? "No email" : user.email),
          Expanded(
            child: Center(
              child: Text(
                isActive ? 'Active' : 'Blocked',
                style: CustomTextStyles.userStatus(isActive),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? AppColors.deepBlue : Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => UserController.toggleUserStatus(
                  context: context,
                  user: user,
                ),
                child: Text(
                  isActive ? 'Block' : 'Unblock',
                  style: const TextStyle(color: AppColors.pureWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
