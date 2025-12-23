import 'package:dio/dio.dart';
import '../../model/event_model.dart';

abstract class EventRepository {
  Future<EventModel?> createEvent(FormData data);
  Future<List<EventModel>> getEvents();
  Future<EventModel?> getEventById(String eventId);
  Future<bool> purchaseTicket(String eventId);
}
