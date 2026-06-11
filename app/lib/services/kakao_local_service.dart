import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/place.dart';
import '../secrets/kakao_keys.dart';

class KakaoLocalService {
  static const String _host = 'dapi.kakao.com';

  Future<List<Place>> searchAnimalHospitals({
    required double latitude,
    required double longitude,
    int radius = 5000,
  }) async {
    final uri = Uri.https(
      _host,
      '/v2/local/search/keyword.json',
      {
        'query': '동물병원',
        'x': longitude.toString(),
        'y': latitude.toString(),
        'radius': radius.toString(),
        'sort': 'distance',
        'size': '15',
      },
    );

    debugPrint('카카오 Local API 요청 URL: $uri');
    debugPrint('요청 위도: $latitude');
    debugPrint('요청 경도: $longitude');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'KakaoAK ${KakaoKeys.restApiKey}',
      },
    );

    debugPrint('카카오 응답 상태 코드: ${response.statusCode}');
    debugPrint('카카오 응답 본문: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        '카카오 Local API 호출 실패\n상태 코드: ${response.statusCode}\n응답: ${response.body}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List documents = data['documents'] ?? [];

    return documents.map((item) => Place.fromJson(item)).toList();
  }
}