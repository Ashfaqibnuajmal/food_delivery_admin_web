import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/categories/presentation/screens/catagories_screen.dart';
import 'package:user_app/features/chat/chat_screen.dart' show ChatScreen;
import 'package:user_app/features/dashboard/dashboard_screen.dart';
import 'package:user_app/features/due%20payment/presentation/screens/due_payment_screen.dart';
import 'package:user_app/features/expances/presentation/screens/expance_screen.dart';
import 'package:user_app/features/foods/presentation/screens/fooditem_screen.dart';
import 'package:user_app/features/orders/presentation/screens/order_screen.dart';
import 'package:user_app/features/users/presentation/screens/user_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              showHamburger: true,
              hoverColor: AppColors.lightBlue.withOpacity(0.3),
              selectedColor: AppColors.mediumBlue,
              selectedTitleTextStyle: const TextStyle(
                color: AppColors.pureWhite,
              ),
              selectedIconColor: AppColors.pureWhite,
              unselectedTitleTextStyle: const TextStyle(
                color: AppColors.lightBlue,
              ),
              unselectedIconColor: AppColors.lightBlue,
              backgroundColor: AppColors.darkBlue,
            ),
            title: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Hotel Admin',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            items: [
              SideMenuItem(
                title: 'Dashboard',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.dashboard, color: AppColors.lightBlue),
              ),
              SideMenuItem(
                title: 'Orders',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.reorder, color: AppColors.lightBlue),
              ),
              SideMenuItem(
                title: 'Food Items',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.fastfood, color: AppColors.lightBlue),
              ),
              SideMenuItem(
                title: 'Users',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.people, color: AppColors.lightBlue),
              ),
              SideMenuItem(
                title: 'Chat',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.chat, color: AppColors.lightBlue),
              ),
              SideMenuItem(
                title: 'Categories',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.category, color: AppColors.lightBlue),
              ),
              SideMenuItem(
                title: 'Expance',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(
                  Icons.currency_exchange_rounded,
                  color: AppColors.lightBlue,
                ),
              ),
              SideMenuItem(
                title: 'Due Payment',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(
                  Icons.attach_money,
                  color: AppColors.lightBlue,
                ),
              ),
            ],
          ),
          const VerticalDivider(width: 1, color: Colors.black12),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                const DashboardScreen(),
                const OrderScreen(),
                const FooditemScreen(),
                const UsersScreen(),
                const ChatScreen(),
                CatagoriesScreen(),
                const ExpanceScreen(),
                const DuePaymentScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
