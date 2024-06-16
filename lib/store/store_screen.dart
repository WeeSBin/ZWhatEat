import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../base/determine_position.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

Future<void> searchNearbyRestaurants() async {
  String? apiKey = dotenv.env['KAKAO_API_KEY'];
  if (apiKey == null) {
    throw Exception("카카오 API 키 로드 실패");
  }

  var headers = {
    'Authorization': 'KakaoAK $apiKey'
  };

  Position position = await determinePosition();
  print('Current Location: ${position.latitude}, ${position.longitude}');

  int radius = 1000;

  var url = Uri.parse(
      'https://dapi.kakao.com/v2/local/search/category.json?category_group_code=FD6&x=${position.longitude}&y=${position.latitude}&radius=$radius');

  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
  } else {
    throw Exception('Failed to load nearby restaurants');
  }
}

class _StoreScreenState extends State<StoreScreen> {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print("Click!!!");
        searchNearbyRestaurants();
      },
      child: const Text("BUTTON"),
    );
  }
}
