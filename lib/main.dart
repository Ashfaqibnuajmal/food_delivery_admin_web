import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/constants/firebase_options.dart';
import 'package:user_app/core/provider/multiple_image_provider.dart';
import 'package:user_app/core/provider/pick_image.dart';
import 'package:user_app/core/provider/user_search_provider.dart';
import 'package:user_app/features/auth/provider/login_provider.dart';
import 'package:user_app/features/categories/data/services/category_services.dart';
import 'package:user_app/features/categories/presentation/provider/category_provider.dart';
import 'package:user_app/features/chat/data/services/chat_services.dart';
import 'package:user_app/features/chat/logic/provider/chat_provider.dart';
import 'package:user_app/features/due_payment/provider/due_entry_action_provider.dart';
import 'package:user_app/features/due_payment/provider/due_entry_form_validator.dart';
import 'package:user_app/features/due_payment/provider/due_user_action_provider.dart';
import 'package:user_app/features/expances/presentation/provider/expense_provider.dart';
import 'package:user_app/features/foods/data/services/food_item_services.dart';
import 'package:user_app/features/foods/provider/dialogstateprovider.dart';
import 'package:user_app/features/home/home.dart';
import 'package:user_app/features/notification/provider/notification_provider.dart';
import 'package:user_app/features/users/data/services/user_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryServices>(
          create: (_) => CategoryServices(),
        ),
        ChangeNotifierProxyProvider<CategoryServices, CategoryProvider>(
          create: (context) =>
              CategoryProvider(context.read<CategoryServices>()),
          update: (_, categoryServices, previous) {
            return previous ?? CategoryProvider(categoryServices);
          },
        ),
        ChangeNotifierProvider<ImageProviderModel>(
          create: (_) => ImageProviderModel(),
        ),
        ChangeNotifierProvider<MultipleImageProvider>(
          create: (_) => MultipleImageProvider(),
        ),
        ChangeNotifierProvider<LoginController>(
          create: (_) => LoginController(),
        ),
        ChangeNotifierProvider<ExpenseProvider>(
          create: (_) => ExpenseProvider(),
        ),
        ChangeNotifierProvider<FoodItemServices>(
          create: (_) => FoodItemServices(),
        ),
        ChangeNotifierProvider<AddFoodDialogProvider>(
          create: (_) => AddFoodDialogProvider(),
        ),
        ChangeNotifierProvider<ChatServices>(create: (_) => ChatServices()),
        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider<ChatListProvider>(
          create: (_) => ChatListProvider(),
        ),
        ChangeNotifierProvider<UserServices>(create: (_) => UserServices()),

        // Due payment providers
        ChangeNotifierProvider<DueUserActionProvider>(
          create: (_) => DueUserActionProvider(),
        ),
        ChangeNotifierProvider<DueEntryFormProvider>(
          create: (_) => DueEntryFormProvider(),
        ),
        ChangeNotifierProvider<DueEntryActionProvider>(
          create: (_) => DueEntryActionProvider(),
        ),

        ChangeNotifierProxyProvider<UserServices, UserSearchProvider>(
          create: (context) => UserSearchProvider(context.read<UserServices>()),
          update: (_, userService, previous) {
            return previous ?? UserSearchProvider(userService);
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
