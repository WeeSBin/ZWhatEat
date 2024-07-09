import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:whateat/model/category_model.dart';

import '../base/determine_position.dart';
import '../model/restaurant_model.dart';

class StoreScreen extends StatefulWidget {
  final CategoryModel lastCategory;

  const StoreScreen({super.key, required this.lastCategory});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<Restaurant> restaurants = [];
  List<bool> isSelected = [true, false]; // 초기 선택 상태
  String currentSort = 'distance';

  // todo 조회 페이징 적용
  // todo 뒤로가기하면 category_screen으로 다시 돌아가게끔
  // todo radius 선택할수 있게끔 클릭 하면 500 1000 늘어나다가 다시 500으로 돌아오는 식으로
  // todo 주소보단 카테고리를 띄우는게 더 의미가 있지 않을까
  // todo 조회 중에 로딩 중 표시 띄우기

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 정렬 및 필터링 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ToggleButtons(
              renderBorder: false,
              constraints: const BoxConstraints(
                minHeight: 30,
                minWidth: 60,
              ),
              borderColor: Colors.grey,
              fillColor: Colors.blue,
              borderWidth: 0,
              selectedBorderColor: Colors.blue,
              selectedColor: Colors.white,
              onPressed: (int index) {
                sortTogglePressed(index);
              },
              isSelected: isSelected,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('거리 순'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('정확도 순'),
                ),
              ],
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
                  trailing: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${restaurant.distance}m'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void sortTogglePressed(int index) {
    setState(() {
      for (int buttonIndex = 0;
          buttonIndex < isSelected.length;
          buttonIndex++) {
        isSelected[buttonIndex] = buttonIndex == index;
      }
      currentSort = index == 0 ? 'distance' : 'accuracy';
      searchNearbyRestaurants();
    });
  }

  @override
  void initState() {
    super.initState();
    searchNearbyRestaurants();
  }

  Future<void> _launchUrl(Uri url) async {
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

    int radius = 2000;

    var url = Uri.parse('https://dapi.kakao.com/v2/local/search/keyword.json?'
        'query=${widget.lastCategory.name}'
        '&category_group_code=FD6'
        '&x=${position.longitude}'
        '&y=${position.latitude}'
        '&radius=$radius'
        '&sort=$currentSort');

    // fixme
    print('searchNearbyRestaurants: ${url.toString()}');
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
