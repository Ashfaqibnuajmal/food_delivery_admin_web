import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/functions/image_functions.dart';
import 'package:user_app/core/provider/pick_image.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/widgets/customtextfield.dart';

Future<void> showEditCategoryDialog({
  required BuildContext context,
  required String currentName,
  String? oldImage,
  required void Function(String newName) onSave,
}) async {
  final nameController = TextEditingController(text: currentName);

  await showDialog(
    context: context,
    builder: (context) {
      final imageProvider = Provider.of<ImageProviderModel>(context);

      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Picker Container
              GestureDetector(
                onTap: () async {
                  try {
                    final image = await pickImage();
                    imageProvider.setImage(image);
                  } catch (e) {
                    log(e.toString());
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blueGrey, width: 2),
                    color: Colors.grey[200],
                  ),
                  height: 200,
                  width: double.infinity,
                  child: imageProvider.pickedImage != null
                      ? Image.memory(
                          imageProvider.pickedImage!,
                          fit: BoxFit.contain,
                        )
                      : oldImage != null
                      ? Image.network(oldImage, fit: BoxFit.contain)
                      : const Center(
                          child: Text(
                            "Click here to add image!",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Category Name TextField
              CustemTextFIeld(
                label: "Enter category name",
                controller: nameController,
              ),
              const SizedBox(height: 20),

              // Save Changes Button
              ElevatedButton(
                onPressed: () {
                  final newName = nameController.text.trim();
                  if (newName.isNotEmpty) {
                    onSave(newName);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: CustomTextStyles.addCategory,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
