import 'dart:developer';

import 'package:dio/dio.dart';

import '../../config/get_it.dart';
import '../../constants/api_constants.dart';
import '../../model/stream_model.dart';
import '../../services/dio_config.dart';
import 'stream_repository.dart';

class StreamRepositoryImpl implements StreamRepository {
  final Dio _dio = DioConfig.dio;
  final LoggerService _logger = getIt<LoggerService>();

  @override
  Future<EventStreamJoinData?> joinEventStream({
    required String eventId,
    required int uid,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/events/$eventId/join',
        data: {'uid': uid},
      );
      _logger.info(
        'joinEventStream response: ${response.statusCode} ${response.data}',
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final payload = Map<String, dynamic>.from(data['data'] ?? data);
          return EventStreamJoinData.fromJson(payload);
        }
      }

      _logger.warning(
        'joinEventStream failed with status ${response.statusCode}',
      );
      return null;
    } on DioException catch (error) {
      _logger.error('joinEventStream Dio error: ${error.message}');
      return null;
    } catch (error) {
      _logger.error('joinEventStream unexpected error: $error');
      return null;
    }
  }
}
