import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:user_app/core/constants/firebase_options.dart';
import 'package:user_app/core/provider/pick_image.dart';
import 'package:user_app/core/provider/user_search_provider.dart';
import 'package:user_app/features/categories/data/services/category_sevices.dart';
import 'package:user_app/features/expances/provider/expance_provider.dart';
import 'package:user_app/features/foods/data/services/food_item_services.dart';
import 'package:user_app/features/foods/provider/dialogstateprovider.dart';
import 'package:user_app/features/home/home.dart';

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
        ChangeNotifierProvider<CategorySevices>(
          create: (_) => CategorySevices(),
        ),
        ChangeNotifierProvider<ImageProviderModel>(
          create: (_) => ImageProviderModel(),
        ),
        ChangeNotifierProvider(create: (_) => UserSearchProvider()),
        ChangeNotifierProvider<ExpenseProvider>(
          create: (_) => ExpenseProvider(),
        ),
        ChangeNotifierProvider<FoodItemServices>(
          create: (_) => FoodItemServices(),
        ),
        ChangeNotifierProvider<AddFoodDialogProvider>(
          create: (_) => AddFoodDialogProvider(),
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
