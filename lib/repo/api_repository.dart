import 'dart:convert';

import 'package:gompa_tour/helper/database_helper.dart';
import 'package:gompa_tour/states/festival_state.dart';
import 'package:gompa_tour/states/gonpa_state.dart';
import 'package:gompa_tour/states/pilgrim_site_state.dart';
import 'package:gompa_tour/states/statue_state.dart';
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
        final String decodedBody =
            const Utf8Decoder().convert(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedBody);
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

  // search by title and content of the data based on category
  Future<List<T>> searchByTitleAndContentAndCategory(
    String query,
    String category,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/$endpoint/?sect=${category}'),
      );

      if (response.statusCode == 200) {
        final String decodedBody =
            const Utf8Decoder().convert(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedBody);
        return data.map((json) => fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      logger.severe('Failed to search data by category: $e');
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

  // get data by id
  Future<T?> getById(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/$endpoint/$id'),
      );
      if (response.statusCode == 200) {
        final String decodedBody =
            const Utf8Decoder().convert(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(decodedBody);
        return fromJson(data);
      }
      return null;
    } catch (e) {
      logger.severe('Failed to get data by id: $e');
      return null;
    }
  }

  // get types
  Future<List<String>> getTypes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint/types'),
      );

      if (response.statusCode == 200) {
        // convert the response body to a List of strings and return
        final List<dynamic> data = json.decode(response.body);
        return data.map((type) => type.toString()).toList();
      }
      return [];
    } catch (e) {
      logger.severe('Failed to get types: $e');
      return [];
    }
  }

  // filter data by type and category
  Future<List<T>> filterByTypeAndCategory(String type, String category) async {
    try {
      final response = category == 'ALL'
          ? await _client.get(Uri.parse('$baseUrl/$endpoint/?type=$type'))
          : await _client.get(
              Uri.parse('$baseUrl/$endpoint/?sect=$category&type=$type'),
            );
      if (response.statusCode == 200) {
        final String decodedBody =
            const Utf8Decoder().convert(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedBody);
        return data.map((json) => fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      logger.severe('Failed to filter data: $e');
      return [];
    }
  }
}

class SearchRepository {
  final StatueNotifier statueNotifier;
  final GonpaNotifier gonpaNotifier;
  final PilgrimSiteNotifier pilgrimSiteNotifier;
  final FestivalNotifier festivalNotifier;

  SearchRepository(
    this.statueNotifier,
    this.gonpaNotifier,
    this.pilgrimSiteNotifier,
    this.festivalNotifier,
  );

  Future<List<dynamic>> searchAcrossTables(String queryText) async {
    final query = queryText.replaceAll("'", "''");

    // get all the statues
    final statues = await statueNotifier.fetchAllStatues();

    final stateQuery = statues.where((statue) {
      return statue.translations.any((translation) {
        return (translation.name.toLowerCase().contains(query.toLowerCase()));
      });
    }).toList();

    // get all the gonpas
    final gonpas = await gonpaNotifier.fetchAllGonpas();

    final gonpaQuery = gonpas.where((gonpa) {
      return gonpa.translations.any((translation) {
        return (translation.name.toLowerCase().contains(query.toLowerCase()));
      });
    }).toList();

    // get all the pilgrim sites
    final pilgrimSites = await pilgrimSiteNotifier.fetchAllPilgrimSites();

    final pilgrimSiteQuery = pilgrimSites.where((pilgrimSite) {
      return pilgrimSite.translations.any((translation) {
        return (translation.name.toLowerCase().contains(query.toLowerCase()));
      });
    }).toList();

    // get all the festivals
    final festivals = await festivalNotifier.fetchAllFestivals();

    final festivalQuery = festivals.where((festival) {
      return festival.translations.any((translation) {
        return (translation.name.toLowerCase().contains(query.toLowerCase()));
      });
    }).toList();

    final combineResults = [
      ...stateQuery,
      ...gonpaQuery,
      ...pilgrimSiteQuery,
      ...festivalQuery,
    ];

    return combineResults;
  }
}
