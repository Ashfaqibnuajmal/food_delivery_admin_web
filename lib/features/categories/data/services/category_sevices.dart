import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/categories/data/models/category_model.dart';

class CategorySevices extends ChangeNotifier {
  final categoryCollection = FirebaseFirestore.instance.collection("Category");
  static const cloudName = "dsuwmcmw4";
  static const cloudPresent = "flutter_uploads";
  static const cloudApiKey = "837695524881733";
  static const cloudApiSecretKey = "BMxWLGuxc0qhl2QAlwmLsXXS3k0";

  Future<bool> isCategoryExist(String name) async {
    final nameLower = name.toLowerCase();
    try {
      final snapshot = await categoryCollection.get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final categoryName = (data['name'] ?? '') as String;
        if (categoryName.toLowerCase() == nameLower) {
          return true;
        }
      }

      return false;
    } catch (e) {
      log("Error checking category existence:$e");
      return false;
    }
  }

  // In CategorySevices
  Future<void> addCategory(String name, List<String> imageUrls) async {
    try {
      final catagoryExist = await isCategoryExist(name);
      if (catagoryExist) {
        throw Exception("Category with the name $name already exists!");
      }

      if (imageUrls.isEmpty) {
        throw "No images provided";
      }

      final docref = categoryCollection.doc();
      final categoryModel = CategoryModel(
        categoryUid: docref.id,
        name: name,
        imageUrls: imageUrls, // Store URLs
      );

      await categoryCollection
          .doc(categoryModel.categoryUid)
          .set(categoryModel.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  /// Edit category (multiple images)
  Future<void> editCategory(
    CategoryModel category,
    List<String> oldImages,
  ) async {
    try {
      // Delete removed images
      for (var oldImg in oldImages) {
        if (!category.imageUrls.contains(oldImg)) {
          await deleteImageFromCloudinary(oldImg);
        }
      }

      await categoryCollection
          .doc(category.categoryUid)
          .update(category.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  /// Delete category (all images)
  Future<void> deleteCategory(CategoryModel category) async {
    try {
      for (var img in category.imageUrls) {
        await deleteImageFromCloudinary(img);
      }
      await categoryCollection.doc(category.categoryUid).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  /// Fetch categories
  Stream<List<CategoryModel>> fetchCatagories() {
    return categoryCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((snapshot) => CategoryModel.fromMap(snapshot.data()))
          .toList(),
    );
  }

  /// Upload single image to Cloudinary
  Future<String?> sendImageToCloudinary(Uint8List image) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );
      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = cloudPresent
        ..files.add(
          http.MultipartFile.fromBytes("file", image, filename: "categoryname"),
        );

      final response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        return jsonDecode(res.body)["secure_url"];
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  /// Delete image from Cloudinary
  Future<void> deleteImageFromCloudinary(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Find the index of the upload preset in the path
      int presetIndex = pathSegments.indexOf(cloudPresent);

      // If preset not found, try to extract public_id differently
      String publicId;
      if (presetIndex == -1) {
        // URL format: https://res.cloudinary.com/[cloudName]/image/upload/v[version]/[publicId].[extension]
        // Find the version (starts with 'v')
        int versionIndex = -1;
        for (int i = 0; i < pathSegments.length; i++) {
          if (pathSegments[i].startsWith('v') && pathSegments[i].length > 1) {
            final versionPart = pathSegments[i].substring(1);
            if (int.tryParse(versionPart) != null) {
              versionIndex = i;
              break;
            }
          }
        }

        if (versionIndex != -1 && versionIndex + 1 < pathSegments.length) {
          // Get everything after version and remove extension
          final fileWithExt = pathSegments.sublist(versionIndex + 1).join('/');
          publicId = fileWithExt.substring(0, fileWithExt.lastIndexOf('.'));
        } else {
          // Fallback: get last segment and remove extension
          final lastSegment = pathSegments.last;
          publicId = lastSegment.substring(0, lastSegment.lastIndexOf('.'));
        }
      } else {
        // Extract public_id from preset onwards
        final fileWithExt = pathSegments.sublist(presetIndex + 1).join('/');
        publicId = fileWithExt.substring(0, fileWithExt.lastIndexOf('.'));
      }

      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/delete",
      );
      final response = await http.post(
        url,
        headers: {
          "Authorization":
              "Basic ${base64Encode(utf8.encode('$cloudApiKey:$cloudApiSecretKey'))}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "public_ids": [publicId],
        }),
      );

      if (response.statusCode == 200) {
        log("Image deleted from cloudinary: $publicId");
      } else {
        log(
          "Failed to delete image from Cloudinary: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      log("Error deleting image from Cloudinary : $e");
    }
  }
}
