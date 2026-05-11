import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:user_app/features/categories/data/models/category_model.dart';
import 'package:user_app/features/categories/data/services/category_services.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryServices _categoryServices;

  CategoryProvider(this._categoryServices);

  // ─── State ───────────────────────────────────────────────
  bool _isLoading = false;
  String? _errorMessage;
  List<CategoryModel> _categories = [];

  // ─── Getters ─────────────────────────────────────────────
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CategoryModel> get categories => _categories;

  // ─── Internal Helpers ────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ─── Fetch Categories (Stream) ───────────────────────────
  Stream<List<CategoryModel>> fetchCategories() {
    return _categoryServices.fetchCategories();
  }

  // ─── Add Category ────────────────────────────────────────
  Future<bool> addCategory({
    required String name,
    required List<Uint8List> images,
  }) async {
    if (name.trim().isEmpty || images.isEmpty) {
      _setError("Enter name and pick at least one image");
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      final List<String> uploadedUrls = [];

      for (var image in images) {
        final url = await _categoryServices.sendImageToCloudinary(image);
        if (url != null) uploadedUrls.add(url);
      }

      if (uploadedUrls.isEmpty) {
        _setError("Failed to upload images. Please try again.");
        return false;
      }

      await _categoryServices.addCategory(name.trim(), uploadedUrls);
      return true;
    } catch (e) {
      log("Add Category Error: $e");
      _setError("Failed to add category: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─── Edit Category ───────────────────────────────────────
  Future<bool> editCategory({
    required CategoryModel oldModel,
    required String newName,
    required List<Uint8List> newImages,
  }) async {
    if (newName.trim().isEmpty) {
      _setError("Name cannot be empty");
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      List<String> finalImageUrls = oldModel.imageUrls;

      if (newImages.isNotEmpty) {
        final uploadedUrls = <String>[];
        for (var img in newImages) {
          final url = await _categoryServices.sendImageToCloudinary(img);
          if (url != null) uploadedUrls.add(url);
        }
        finalImageUrls = [...oldModel.imageUrls, ...uploadedUrls];
      }

      final updatedModel = CategoryModel(
        categoryUid: oldModel.categoryUid,
        name: newName.trim(),
        imageUrls: finalImageUrls,
      );

      await _categoryServices.editCategory(updatedModel, oldModel.imageUrls);
      return true;
    } catch (e) {
      log("Edit Category Error: $e");
      _setError("Failed to edit category: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─── Delete Category ─────────────────────────────────────
  Future<bool> deleteCategory(CategoryModel model) async {
    _setLoading(true);
    _setError(null);

    try {
      await _categoryServices.deleteCategory(model);
      return true;
    } catch (e) {
      log("Delete Category Error: $e");
      _setError("Failed to delete category: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─── Validate Name ───────────────────────────────────────
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }
    return null;
  }
}
