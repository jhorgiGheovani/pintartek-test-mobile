import '../models/video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoService {
  static const String baseUrl =
      'https://apivideoplayer-production.up.railway.app/api/videos';

  Future<List<Video>> fetchVideos() async {
    // throw Exception('Simulasi error - koneksi internet bermasalah!');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/all'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('Videos loaded: ${jsonData.length}');
        return jsonData.map((json) => Video.fromJson(json)).toList();
      } else {
        print('Failed to load videos: ${response.statusCode}');
        throw Exception('Failed to load videos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching videos: $e');
      throw Exception('Error fetching videos: $e');
    }
  }
}
