import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../base/determine_position.dart';
import 'model/restaurant_model.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<Restaurant> restaurants = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 정렬 및 필터링 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // 필터 로직
              },
              child: const Text('필터'),
            ),
            ElevatedButton(
              onPressed: () {
                // 정렬 로직
              },
              child: const Text('정렬'),
            ),
          ],
        ),
        // 리스트 뷰
        Expanded(
          child: ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return Container(
                decoration: const BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                )),
                child: ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: restaurant.name,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchUrl(restaurant.placeUrl);
                            },
                        ),
                      ],
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  subtitle: Text(restaurant.address),
                  trailing: Text('${restaurant.distance}m'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    searchNearbyRestaurants();
  }

  Future<void> _launchUrl(Uri url) async {
    print(url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> searchNearbyRestaurants() async {
    String? apiKey = dotenv.env['KAKAO_API_KEY'];
    if (apiKey == null) {
      throw Exception("카카오 API 키 로드 실패");
    }

    var headers = {'Authorization': 'KakaoAK $apiKey'};

    Position position = await determinePosition();

    int radius = 5000;

    var url = Uri.parse('https://dapi.kakao.com/v2/local/search/category.json?'
        'category_group_code=FD6'
        '&x=${position.longitude}'
        '&y=${position.latitude}'
        '&radius=$radius'
        '&sort=distance');

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body)['documents'] as List;
      setState(() {
        restaurants =
            jsonResponse.map((data) => Restaurant.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load nearby restaurants');
    }
  }
}
