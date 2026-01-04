import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/event_model.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:1337/api";

  static Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  static Future<bool> registerEvent(int eventId, Map<String, String> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registrations'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "data": {
          ...userData,
          "event": eventId,
        }
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}