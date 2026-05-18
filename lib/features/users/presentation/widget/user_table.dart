import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/user_search_provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/header_cell.dart';
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

    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withOpacity(0.1),
        border: Border.all(color: AppColors.deepBlue, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Container(
            height: isMobile ? 45 : 50,
            decoration: const BoxDecoration(
              color: AppColors.deepBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: const Row(
              children: [
                HeaderCell('Name'),
                HeaderCell('Phone No'),
                HeaderCell('Email'),
                HeaderCell('Status'),
                HeaderCell('Action'),
              ],
            ),
          ),

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

class UserTableRow extends StatelessWidget {
  final UserModel user;

  const UserTableRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    final isActive = user.status.toLowerCase() == 'active';

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 10 : 12),
      child: Row(
        children: [
          DataCellText(user.name.isEmpty ? "No name" : user.name),

          DataCellText(user.phone.isEmpty ? "No number" : user.phone),

          DataCellText(user.email.isEmpty ? "No email" : user.email),

          Expanded(
            child: Center(
              child: Text(
                isActive ? 'Active' : 'Blocked',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.userStatus(
                  isActive,
                ).copyWith(fontSize: isMobile ? 11 : null),
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? AppColors.deepBlue : Colors.green,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 18,
                    vertical: isMobile ? 6 : 8,
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
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: isMobile ? 11 : 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
