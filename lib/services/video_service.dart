import '../models/video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoService {
  static const String baseUrl =
      'https://apivideoplayer-production.up.railway.app/api/videos';

  Future<List<Video>> fetchVideos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/all'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Video.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load videos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching videos: $e');
    }
  }
}
