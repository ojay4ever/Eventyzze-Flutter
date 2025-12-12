import 'package:eventyzze/config/get_it.dart';
import 'package:eventyzze/model/event_model.dart';
import 'package:eventyzze/model/stream_model.dart';
import 'package:eventyzze/repositories/eventRepository/event_repository.dart';
import 'package:eventyzze/repositories/streamRepository/stream_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final EventRepository _eventRepository = getIt<EventRepository>();
  final StreamRepository _streamRepository = getIt<StreamRepository>();

  final RxList<EventModel> trendingEvents = <EventModel>[].obs;
  final RxBool isLoadingTrending = false.obs;
  final RxString trendingError = ''.obs;
  final RxBool isJoiningStream = false.obs;
  final RxString joinError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrendingEvents();
  }

  Future<void> fetchTrendingEvents() async {
    try {
      trendingError.value = '';
      isLoadingTrending.value = true;
      final events = await _eventRepository.getEvents();
      trendingEvents.assignAll(events);
    } catch (e) {
      trendingError.value = 'Unable to load events. Please try again.';
    } finally {
      isLoadingTrending.value = false;
    }
  }

  Future<EventStreamJoinData?> joinEventStream({
    required String eventId,
    required int uid,
  }) async {
    try {
      joinError.value = '';
      isJoiningStream.value = true;
      final response = await _streamRepository.joinEventStream(
        eventId: eventId,
        uid: uid,
      );
      if (response == null || response.agoraToken.isEmpty) {
        joinError.value = 'Unable to join stream right now.';
      }
      return response;
    } catch (e) {
      joinError.value = 'Something went wrong while joining.';
      return null;
    } finally {
      isJoiningStream.value = false;
    }
  }
}
