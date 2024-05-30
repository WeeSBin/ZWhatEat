import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

Future<void> fetchPlaces() async {
  // todo env 도입
  // todo Geolocator 위도 경도 확인
  const String apiKey = '';
  var headers = {
    'Authorization': 'KakaoAK $apiKey'
  };
  var url = Uri.parse('https://dapi.kakao.com/v2/local/search/category.json?category_group_code=PM9&radius=20000');

  try {
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      print('API Response: ${response.body}');
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Caught exception: $e');
  }
}

class _StoreScreenState extends State<StoreScreen> {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print("Click!!!");
        fetchPlaces();
      },
      child: const Text("BUTTON"),
    );
  }
}
