import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../category/model/category_model.dart';
import '../repository/customer_category_repository.dart';

// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final customerCategoryRepositoryProvider =
Provider<CustomerCategoryRepository>((ref) {
  return CustomerCategoryRepository();
});

// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final customerCategoryViewModelProvider =
StateNotifierProvider<
    CustomerCategoryViewModel,
    AsyncValue<List<CategoryModel>>>(
      (ref) => CustomerCategoryViewModel(
    ref.read(customerCategoryRepositoryProvider),
  ),
);

// ============================================================
// VIEW MODEL
// ============================================================

class CustomerCategoryViewModel
    extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final CustomerCategoryRepository _repository;

  CustomerCategoryViewModel(this._repository)
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
  // REFRESH
  // ============================================================

  Future<void> refreshCategories() async {
    await getCategories();
  }
}