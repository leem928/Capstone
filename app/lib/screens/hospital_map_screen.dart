import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/place.dart';
import '../services/kakao_local_service.dart';
import '../services/location_service.dart';
import '../theme/app_colors.dart';

class HospitalMapScreen extends StatefulWidget {
  const HospitalMapScreen({super.key});

  @override
  State<HospitalMapScreen> createState() => _HospitalMapScreenState();
}

class _HospitalMapScreenState extends State<HospitalMapScreen> {
  final KakaoLocalService _kakaoLocalService = KakaoLocalService();
  final LocationService _locationService = LocationService();

  bool _isLoading = false;
  String? _errorMessage;
  List<Place> _places = [];

  @override
  void initState() {
    super.initState();
    _loadNearbyHospitals();
  }

  Future<void> _loadNearbyHospitals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _places = [];
    });

    try {
      final position = await _locationService.getCurrentPosition();

      final places = await _kakaoLocalService.searchAnimalHospitals(
        latitude: position.latitude,
        longitude: position.longitude,
        radius: 5000,
      );

      if (!mounted) return;

      setState(() {
        _places = places;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openKakaoPlace(String url) async {
    if (url.isEmpty) {
      _showMessage('장소 상세 페이지 정보가 없습니다.');
      return;
    }

    final uri = Uri.parse(url);

    final success = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!success) {
      _showMessage('카카오맵 장소 페이지를 열 수 없습니다.');
    }
  }

  Future<void> _callHospital(String phone) async {
    if (phone.isEmpty) {
      _showMessage('전화번호 정보가 없습니다.');
      return;
    }

    final cleanedPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanedPhone');

    final success = await launchUrl(uri);

    if (!success) {
      _showMessage('전화 앱을 열 수 없습니다.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '주변 동물병원',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadNearbyHospitals,
            icon: const Icon(
              Icons.refresh,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorArea();
    }

    if (_places.isEmpty) {
      return _buildEmptyArea();
    }

    return Column(
      children: [
        _buildResultHeader(),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _loadNearbyHospitals,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: _places.length,
              itemBuilder: (context, index) {
                final place = _places[index];
                return _buildHospitalCard(place);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.my_location,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '현재 위치 기준 ${_places.length}개의 동물병원을 찾았습니다.',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(Place place) {
    final address = place.roadAddress.isNotEmpty
        ? place.roadAddress
        : place.address;

    final distanceText = place.distance.isNotEmpty
        ? '${place.distance}m'
        : '거리 정보 없음';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            place.name.isNotEmpty ? place.name : '이름 정보 없음',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          _infoRow(
            Icons.near_me_rounded,
            '거리: $distanceText',
          ),

          _infoRow(
            Icons.call_outlined,
            place.phone.isNotEmpty
                ? '전화: ${place.phone}'
                : '전화: 정보 없음',
          ),

          _infoRow(
            Icons.location_on_outlined,
            address.isNotEmpty
                ? '주소: $address'
                : '주소: 정보 없음',
          ),

          _infoRow(
            Icons.access_time_rounded,
            '영업시간: 상세보기에서 확인',
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _openKakaoPlace(place.placeUrl);
                  },
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('상세보기'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    side: const BorderSide(
                      color: AppColors.border,
                    ),
                    backgroundColor: AppColors.surface,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: place.phone.isEmpty
                      ? null
                      : () {
                          _callHospital(place.phone);
                        },
                  icon: const Icon(Icons.call),
                  label: const Text('전화하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.soft,
                    foregroundColor: AppColors.primaryDark,
                    disabledBackgroundColor: AppColors.background,
                    disabledForegroundColor: AppColors.textSecondary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorArea() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 52,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 14),
            const Text(
              '주변 동물병원을 불러오지 못했습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _loadNearbyHospitals,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyArea() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadNearbyHospitals,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          SizedBox(height: 120),
          Icon(
            Icons.search_off_rounded,
            size: 58,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            '주변 동물병원 검색 결과가 없습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '현재 위치 기준 반경 안에 검색 결과가 없을 수 있습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}