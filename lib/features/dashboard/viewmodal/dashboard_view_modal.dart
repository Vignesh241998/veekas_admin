import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/dashboard_modal.dart';
import '../repository/dashboard_repository.dart';

// ============================================================
// DASHBOARD REPOSITORY PROVIDER
// ============================================================

final dashboardRepositoryProvider = Provider<DashboardRepository>(
      (ref) {
    return DashboardRepository();
  },
);

// ============================================================
// DASHBOARD VIEW MODEL PROVIDER
// ============================================================

final dashboardViewModelProvider = FutureProvider<
    DashboardResponseModel>((ref) async {
  final repository = ref.watch(
    dashboardRepositoryProvider,
  );

  return repository.getDashboard();
});