import 'dart:convert';

import 'package:gompa_tour/helper/database_helper.dart';
import 'package:http/http.dart' as http;

class ApiRepository<T> {
  final String baseUrl;
  final String endpoint;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final http.Client _client = http.Client();

  ApiRepository({
    required this.baseUrl,
    required this.endpoint,
    required this.fromJson,
    required this.toJson,
  });

  Future<List<T>> getAll() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/$endpoint'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => fromJson(json)).toList();
      }
      throw Exception('Failed to load data');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<T>> getAllPaginated(
    int page,
    int pageSize,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/$endpoint'),
      );

      if (response.statusCode == 200) {
        final String decodedBody =
            const Utf8Decoder().convert(response.bodyBytes);
        final List<dynamic> responseData = json.decode(decodedBody);
        final totalList = responseData.map((json) => fromJson(json)).toList();
        int start = page * pageSize;
        int end = start + pageSize;
        if (end > totalList.length.toInt()) {
          end = totalList.length.toInt();
        }
        final List<T> paginatedList = totalList.sublist(start, end);
        return paginatedList;
      }
      return [];
    } catch (e) {
      logger.severe('Failed to get paginated data: $e');
      return [];
    }
  }

  Future<List<T>> getAllPaginatedByCategory(
    int page,
    int pageSize,
    String category,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/$endpoint/?sect=${category}'),
      );

      if (response.statusCode == 200) {
        final String decodedBody =
            const Utf8Decoder().convert(response.bodyBytes);
        final List<dynamic> responseData = json.decode(decodedBody);
        final totalList = responseData.map((json) => fromJson(json)).toList();
        int start = page * pageSize;
        int end = start + pageSize;
        if (end > totalList.length.toInt()) {
          end = totalList.length.toInt();
        }
        final List<T> paginatedList = totalList.sublist(start, end);
        return paginatedList;
      }
      return [];
    } catch (e) {
      logger.severe('Failed to get paginated data by category: $e');
      return [];
    }
  }

  // search by title and content of the data
  Future<List<T>> searchByTitleAndContent(String query) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/$endpoint'),
      );

      if (response.statusCode == 200) {
        final String decodedBody =
            const Utf8Decoder().convert(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedBody);
        return data.map((json) => fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      logger.severe('Failed to search data: $e');
      return [];
    }
  }

  // get total number of data
  Future<int> getTotalData() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/$endpoint'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.length;
      }
      return 0;
    } catch (e) {
      logger.severe('Failed to get total data: $e');
      return 0;
    }
  }
}
