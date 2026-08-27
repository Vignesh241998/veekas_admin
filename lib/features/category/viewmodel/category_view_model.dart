
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../model/category_model.dart';
import '../repository/category_repository.dart';


// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final categoryRepositoryProvider =
Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});


// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final categoryViewModelProvider =
StateNotifierProvider<
    CategoryViewModel,
    AsyncValue<List<CategoryModel>>
>(
      (ref) => CategoryViewModel(
    ref.read(categoryRepositoryProvider),
  ),
);


// ============================================================
// VIEW MODEL
// ============================================================

class CategoryViewModel
    extends StateNotifier<AsyncValue<List<CategoryModel>>> {

  final CategoryRepository _repository;

  CategoryViewModel(this._repository)
      : super(const AsyncLoading()) {
    getCategories();
  }


  // ============================================================
  // GET CATEGORIES
  // ============================================================

  Future<void> getCategories() async {
    try {
      state = const AsyncLoading();

      final categories =
      await _repository.getCategories();

      state = AsyncData(categories);

    } catch (e, stackTrace) {

      state = AsyncError(
        e,
        stackTrace,
      );
    }
  }


  // ============================================================
  // ADD CATEGORY
  // ============================================================

  Future<bool> addCategory({
    required String categoryName,
    required PlatformFile image,
  }) async {
    try {

      await _repository.addCategory(
        categoryName: categoryName,
        image: image,
      );

      // Refresh category list
      await getCategories();

      return true;

    } catch (e) {

      rethrow;
    }
  }


  // ============================================================
  // UPDATE CATEGORY
  // ============================================================

  Future<bool> updateCategory({
    required int categoryId,
    required String categoryName,
    PlatformFile? image,
  }) async {
    try {

      await _repository.updateCategory(
        categoryId: categoryId,
        categoryName: categoryName,
        image: image,
      );

      // Refresh category list
      await getCategories();

      return true;

    } catch (e) {

      rethrow;
    }
  }


  // ============================================================
  // DELETE CATEGORY
  // ============================================================

  Future<bool> deleteCategory(
      int categoryId,
      ) async {
    try {

      await _repository.deleteCategory(
        categoryId,
      );

      // Refresh category list
      await getCategories();

      return true;

    } catch (e) {

      rethrow;
    }
  }
}