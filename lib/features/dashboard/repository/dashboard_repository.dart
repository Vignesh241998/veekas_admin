import '../../../core/api/dio_client.dart';
import '../modal/dashboard_modal.dart';


class DashboardRepository {
  Future<DashboardResponseModel> getDashboard() async {
    try {
      final response = await DioClient.instance.get(
        '/dashboard',
      );

      return DashboardResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }
}