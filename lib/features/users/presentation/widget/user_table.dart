import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/user_search_provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/due%20payment/presentation/widget/due_payment_screen/due_payment_table_header.dart';
import 'package:user_app/features/users/controller/user_controller.dart';
import 'package:user_app/features/users/data/model/user_model.dart';
import 'package:user_app/features/users/data/services/user_services.dart';
import 'package:user_app/features/users/presentation/widget/user_cell_text.dart';

class UserTable extends StatelessWidget {
  final UserServices userService;

  const UserTable({super.key, required this.userService});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<UserModel>>(
        stream: userService.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.pureWhite),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No users found', style: CustomTextStyles.text),
            );
          }

          // Update provider with fetched users
          context.read<UserSearchProvider>().setUsers(snapshot.data!);

          // Build table body
          return const _UserTableBody();
        },
      ),
    );
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
  final dynamic user;

  const UserTableRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isActive = user.status.toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          DataCellText(user.name),
          DataCellText(user.phone),
          DataCellText(user.email),
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
                onPressed: () => UserTableLogic.handleUserAction(
                  context: context,
                  user: user,
                  isActive: isActive,
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
