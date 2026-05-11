import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/features/foods/data/model/food_item_model.dart';

class CloudinaryUploadResult {
  final String secureUrl;
  final String publicId;

  const CloudinaryUploadResult({
    required this.secureUrl,
    required this.publicId,
  });
}

class FoodItemServices extends ChangeNotifier {
  final foodItemCollection = FirebaseFirestore.instance.collection("FoodItems");

  static const cloudName = "dsuwmcmw4";
  static const cloudPreset = "flutter_uploads";
  static const cloudApiKey = "837695524881733";
  static const cloudApiSecretKey = "BMxWLGuxc0qhl2QAlwmLsXXS3k0";

  Future<bool> isFoodItemExist(String name, {String? currentFoodItemId}) async {
    final nameLower = name.toLowerCase().trim();

    try {
      final snapshot = await foodItemCollection
          .where("nameLower", isEqualTo: nameLower)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return false;

      final existingFoodItemId = snapshot.docs.first.id;

      if (currentFoodItemId != null &&
          existingFoodItemId == currentFoodItemId) {
        return false;
      }

      return true;
    } catch (e) {
      log("Error checking food item existence: $e");
      return false;
    }
  }

  //──────────────────────────────────────────────
  // 🔸 Add new food item (upload image + save Firestore)
  //──────────────────────────────────────────────
  Future<void> addFoodItem(FoodItemModel food, Uint8List image) async {
    try {
      _validateFoodItem(food);
      final exists = await isFoodItemExist(food.name);
      if (exists) {
        throw Exception("Food Item with the name ${food.name} already exists!");
      }
      final uploadResult = await sendImageToCloudinary(image);
      if (uploadResult == null) throw Exception("Image upload failed!");

      final docRef = foodItemCollection.doc();
      final newItem = food.copyWith(
        foodItemId: docRef.id,
        imageUrl: uploadResult.secureUrl,
        cloudinaryPublicId: uploadResult.publicId,
      );

      await foodItemCollection.doc(docRef.id).set(newItem.toCreateMap());
      log("✅ Food item added: ${newItem.foodItemId}");
      notifyListeners();
    } catch (e) {
      log("❌ Error adding food item: $e");
      rethrow;
    }
  }

  //──────────────────────────────────────────────
  // 🔸 Edit food item (replace image if updated)
  //──────────────────────────────────────────────
  Future<void> editFoodItem(
    FoodItemModel foodItem, {
    Uint8List? newImageBytes,
    String? oldImageUrl,
  }) async {
    try {
      _validateFoodItem(foodItem);
      final exists = await isFoodItemExist(
        foodItem.name,
        currentFoodItemId: foodItem.foodItemId,
      );

      if (exists) {
        throw Exception(
          "Food Item with the name ${foodItem.name} already exists!",
        );
      }
      String finalImageUrl = foodItem.imageUrl;
      String finalPublicId = foodItem.cloudinaryPublicId;

      if (newImageBytes != null) {
        // delete and re‑upload
        if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
          await _deleteImageFromCloudinary(foodItem.cloudinaryPublicId);
        }
        final uploaded = await sendImageToCloudinary(newImageBytes);
        if (uploaded == null) {
          throw Exception("Image upload failed!");
        }

        finalImageUrl = uploaded.secureUrl;
        finalPublicId = uploaded.publicId;
      }

      final updated = foodItem.copyWith(
        imageUrl: finalImageUrl,
        cloudinaryPublicId: finalPublicId,
      );
      await foodItemCollection
          .doc(foodItem.foodItemId)
          .update(updated.toUpdateMap());
      log("📝 Food item updated: ${foodItem.foodItemId}");
      notifyListeners();
    } catch (e) {
      log("❌ Error updating food item: $e");
      rethrow;
    }
  }

  //──────────────────────────────────────────────
  // 🔸 Delete food item + image from Cloudinary
  //──────────────────────────────────────────────
  Future<void> deleteFoodItem(FoodItemModel foodItem) async {
    try {
      await _deleteImageFromCloudinary(foodItem.cloudinaryPublicId);
      await foodItemCollection.doc(foodItem.foodItemId).delete();
      log("🗑️  Food item deleted: ${foodItem.foodItemId}");
      notifyListeners();
    } catch (e) {
      log("❌ Error deleting food item: $e");
      rethrow;
    }
  }

  //──────────────────────────────────────────────
  // 🔸 Fetch all food items in realtime
  //──────────────────────────────────────────────
  Stream<List<FoodItemModel>> fetchFoodItems() {
    return foodItemCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return FoodItemModel.fromMap({...data, "foodItemId": doc.id});
      }).toList();
    });
  }

  //──────────────────────────────────────────────
  // 🔹 Upload image to Cloudinary
  //──────────────────────────────────────────────
  Future<CloudinaryUploadResult?> sendImageToCloudinary(Uint8List image) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      final request = http.MultipartRequest("POST", url)
        ..fields["upload_preset"] = cloudPreset
        ..files.add(
          http.MultipartFile.fromBytes(
            "file",
            image,
            filename: "food_item_${DateTime.now().millisecondsSinceEpoch}.jpg",
          ),
        );

      final response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final body = jsonDecode(res.body);

        return CloudinaryUploadResult(
          secureUrl: body["secure_url"],
          publicId: body["public_id"],
        );
      }

      log("Cloudinary upload failed: ${response.statusCode}");
    } catch (e) {
      log("Error uploading image: $e");
    }

    return null;
  }

  //──────────────────────────────────────────────
  // 🔹 Delete image from Cloudinary
  //──────────────────────────────────────────────
  Future<void> _deleteImageFromCloudinary(String publicId) async {
    try {
      if (publicId.isEmpty) return;

      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/destroy",
      );

      final response = await http.post(
        url,
        body: {"upload_preset": cloudPreset, "public_id": publicId},
      );

      if (response.statusCode == 200) {
        log("Image deleted from Cloudinary: $publicId");
      } else {
        log("Cloudinary delete failed: ${response.statusCode}");
      }
    } catch (e) {
      log("Error deleting image from Cloudinary: $e");
    }
  }

  void _validateFoodItem(FoodItemModel foodItem) {
    if (foodItem.name.trim().length < 2) {
      throw Exception("Food name must be at least 2 characters");
    }

    if (foodItem.description.trim().isEmpty) {
      throw Exception("Description is required");
    }

    if (foodItem.category.trim().isEmpty) {
      throw Exception("Category is required");
    }

    if (foodItem.price <= 0) {
      throw Exception("Price must be greater than 0");
    }

    if (foodItem.prepTimeMinutes <= 0) {
      throw Exception("Preparation time must be greater than 0");
    }

    if (foodItem.calories < 0) {
      throw Exception("Calories cannot be negative");
    }

    if (foodItem.isHalfAvailable) {
      if (foodItem.halfPrice == null || foodItem.halfPrice! <= 0) {
        throw Exception("Half price must be greater than 0");
      }

      if (foodItem.halfPrice! >= foodItem.price) {
        throw Exception("Half price must be less than full price");
      }
    }
  }
}
