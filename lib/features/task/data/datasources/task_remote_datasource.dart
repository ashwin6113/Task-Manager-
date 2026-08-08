import '../../../../core/network/api_client.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  final ApiClient _apiClient;

  TaskRemoteDataSource(this._apiClient);

  Future<Map<String, dynamic>> getTasks({required int skip, required int limit}) async {
    final response = await _apiClient.get(
      '/tasks/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final list = (data['data'] as List<dynamic>?)
              ?.map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
              .toList() ??
          [];
      final total = data['total'] as int? ?? 0;
      return {'tasks': list, 'total': total};
    }
    throw Exception('Invalid response format');
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await _apiClient.post(
      '/tasks/',
      data: task.toJson(),
    );

    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] != null) {
      return TaskModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw Exception('Invalid response format');
  }

  Future<TaskModel> updateTask(int taskId, TaskModel task) async {
    final response = await _apiClient.put(
      '/tasks/$taskId',
      data: task.toJson(),
    );

    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] != null) {
      return TaskModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw Exception('Invalid response format');
  }

  Future<TaskModel> deleteTask(int taskId) async {
    final response = await _apiClient.delete(
      '/tasks/$taskId',
    );

    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] != null) {
      return TaskModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw Exception('Invalid response format');
  }
}
