import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('위치 서비스 비활성화 됨.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('위치 접근 권한 거부함');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('위치 권한이 영구적으로 거부됨');
  }

  // 현재 위치 반환
  return await Geolocator.getCurrentPosition();
}