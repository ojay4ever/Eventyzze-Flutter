import '../../model/stream_model.dart';

abstract class StreamRepository {
  Future<EventStreamJoinData?> joinEventStream({
    required String eventId,
    required int uid,
  });
}
