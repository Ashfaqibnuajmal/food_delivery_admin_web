import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/categories/presentation/widget/category_body.dart';
import 'package:user_app/features/categories/presentation/widget/category_header.dart';

// ignore: must_be_immutable
class CatagoriesScreen extends StatelessWidget {
  TextEditingController catagorynameController = TextEditingController();
  CatagoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CategoryHeader(catagorynameController: catagorynameController),
              const SizedBox(height: 10),
              CategoryBody(catagorynameController: catagorynameController),
            ],
          ),
        ),
      ),
    );
  }
}
