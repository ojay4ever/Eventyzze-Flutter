import 'package:dio/dio.dart';
import '../../config/get_it.dart';
import '../../constants/api_constants.dart';
import '../../model/event_model.dart';
import '../../services/dio_config.dart';
import '../eventRepository/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final LoggerService logger = getIt<LoggerService>();
  final Dio _dio = DioConfig.dio;

  @override
  Future<EventModel?> createEvent(FormData data) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/events/create',
        data: data,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = response.data;
        final eventJson = res is Map<String, dynamic>
            ? (res['event'] ?? res['data'] ?? res)
            : <String, dynamic>{};
        return EventModel.fromJson(eventJson);
      }
      return null;
    } on DioException catch (dioError) {
      logger.error('Dio error: ${dioError.message}');
      return null;
    } catch (e) {
      logger.error('Unexpected error: $e');
      return null;
    }
  }

  @override
  Future<List<EventModel>> getEvents() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/events');

      if (response.statusCode == 200) {
        final res = response.data;
        final List<dynamic> eventsList = res is Map<String, dynamic>
            ? (res['events'] ?? res['data'] ?? [])
            : (res is List ? res : []);
        return eventsList.map((e) => EventModel.fromMap(e)).toList();
      }
      return [];
    } on DioException catch (dioError) {
      logger.error('Dio error while fetching events: ${dioError.message}');
      return [];
    } catch (e) {
      logger.error('Unexpected error: $e');
      return [];
    }
  }

  @override
  Future<EventModel?> getEventById(String eventId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/events/$eventId',
      );

      if (response.statusCode == 200) {
        final res = response.data;
        final eventJson = res is Map<String, dynamic>
            ? (res['event'] ?? res['data'] ?? res)
            : <String, dynamic>{};
        return EventModel.fromJson(eventJson);
      }
      logger.error('Failed to fetch event: ${response.statusCode}');
      return null;
    } on DioException catch (dioError) {
      logger.error('Dio error while fetching event: ${dioError.message}');
      return null;
    } catch (e) {
      logger.error('Unexpected error: $e');
      return null;
    }
  }
}
